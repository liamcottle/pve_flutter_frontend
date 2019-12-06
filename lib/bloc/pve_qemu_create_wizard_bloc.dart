import 'dart:async';

import 'package:pve_flutter_frontend/bloc/proxmox_base_bloc.dart';
import 'package:meta/meta.dart';
import 'package:pve_flutter_frontend/models/pve_nodes_qemu_create_model.dart';
import 'package:rxdart/rxdart.dart';

import 'package:pve_flutter_frontend/states/proxmox_form_field_state.dart';
import 'package:proxmox_dart_api_client/proxmox_dart_api_client.dart'
    as proxclient;

class PveQemuCreateWizardBloc extends ProxmoxBaseBloc<PveQemuCreateWizardEvent,
    PveQemuCreateWizardState> {
  PveNodeQemuCreateModel qemu;

  final int stepCount;

  final proxclient.Client apiClient;

  // This stream can be used to inform listerns that there was a validity change
  // somewhere which they need to react on, e.g. the continue button needs to be
  // enabled or disabled.
  final BehaviorSubject<bool> _stepValidationController =
      BehaviorSubject<bool>.seeded(false);
  StreamSink<bool> get inStepValidityChanged => _stepValidationController.sink;
  Stream<bool> get outStepValidityChanged => _stepValidationController.stream;

  // This stream does not change the state of the stepper, it's used to inform
  // listeners that a step change was requested. The current step should
  // react to it and if ready notify the bloc that a state change can be peformed.
  final PublishSubject<int> _requestStepChangeController =
      PublishSubject<int>();
  StreamSink<int> get inRequestStepChange => _requestStepChangeController.sink;
  Stream<int> get outRequestStepChange => _requestStepChangeController.stream;

  List<Stream<PveFormFieldState>> _stepStreamsToValidate = [];
  CombineLatestStream<PveFormFieldState, bool> _stepStatesCombined;
  StreamSubscription<bool> _stepStateCombinedSubscription;

  @override
  PveQemuCreateWizardState get initialState => PveQemuCreateWizardState(0);

  PveQemuCreateWizardBloc({@required this.apiClient, @required this.stepCount});

  @override
  Stream<PveQemuCreateWizardState> processEvents(
      PveQemuCreateWizardEvent event) async* {
    if (event is GoToStep) {
      inStepValidityChanged.add(false);
      if (event.stepIndex == stepCount) {
        await createVirtualMachine(qemu);
        yield PveQemuCreateWizardState(event.stepIndex);
      } else {
        yield PveQemuCreateWizardState(event.stepIndex);
      }
    }
  }

  @override
  void dispose() {
    _stepValidationController?.close();
    _requestStepChangeController?.close();
    super.dispose();
  }

  void addToValidation(Stream<PveFormFieldState> formFieldState) {
    _stepStateCombinedSubscription?.cancel();
    _stepStreamsToValidate.add(formFieldState);
    _stepStatesCombined = CombineLatestStream(_stepStreamsToValidate,
        (values) => !values.any((a) => a?.hasError ?? true));

    _stepStateCombinedSubscription = _stepStatesCombined
        .listen((stepValid) => inStepValidityChanged.add(stepValid));
  }

  void clearValidation() {
    _stepStreamsToValidate.clear();
  }

  Future<void> createVirtualMachine(PveNodeQemuCreateModel qemuConfig) async {
    var url = Uri.parse(proxclient.getPlatformAwareOrigin() +
        '/api2/json/nodes/${qemuConfig.node}/qemu');

    Map<String, String> payload = {
      'name': qemuConfig.name,
      'vmid': qemuConfig.vmid.toString(),
      'scsi0': qemuConfig.scsi0,
      'ostype': qemuConfig.ostype.name,
      'scsihw': 'virtio-scsi-pci',
      'cdrom': qemuConfig.cdrom,
      'sockets': qemuConfig.sockets.toString(),
      'cores': qemuConfig.sockets.toString(),
      'numa': '0',
      'memory': qemuConfig.memory.toString(),
      'net0': qemuConfig.net0,
    };
    var response = await apiClient.post(url,
        headers: {'content-type': 'application/x-www-form-urlencoded'},
        body: payload);
    print(response.body);
  }
}

class PveQemuCreateWizardState {
  final int currentStep;

  PveQemuCreateWizardState(this.currentStep);
}

abstract class PveQemuCreateWizardEvent {}

class GoToStep extends PveQemuCreateWizardEvent {
  final int stepIndex;

  GoToStep(this.stepIndex);
}
