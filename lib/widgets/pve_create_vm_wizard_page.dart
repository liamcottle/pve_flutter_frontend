import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:pve_flutter_frontend/bloc/pve_bridge_selector_bloc.dart';
import 'package:pve_flutter_frontend/bloc/pve_cd_selector_bloc.dart';
import 'package:pve_flutter_frontend/bloc/pve_guest_id_selector_bloc.dart';
import 'package:pve_flutter_frontend/bloc/pve_guest_os_selector_bloc.dart';
import 'package:pve_flutter_frontend/bloc/pve_node_selector_bloc.dart';
import 'package:pve_flutter_frontend/bloc/pve_qemu_create_wizard_bloc.dart';
import 'package:pve_flutter_frontend/bloc/pve_storage_selector_bloc.dart';
import 'package:pve_flutter_frontend/bloc/pve_vm_name_bloc.dart';
import 'package:pve_flutter_frontend/models/pve_nodes_qemu_create_model.dart';
import 'package:pve_flutter_frontend/models/pve_nodes_storage_content_model.dart';
import 'package:pve_flutter_frontend/utils/proxmox_layout_builder.dart';
import 'package:pve_flutter_frontend/widgets/pve_bridge_selector_widget.dart';
import 'package:pve_flutter_frontend/widgets/pve_cd_selector_widget.dart';
import 'package:pve_flutter_frontend/widgets/pve_guest_id_selector_widget.dart';
import 'package:pve_flutter_frontend/widgets/pve_guest_os_selector_widget.dart';
import 'package:pve_flutter_frontend/widgets/pve_network_model_selector.dart';
import 'package:pve_flutter_frontend/widgets/pve_node_selector_widget.dart';
import 'package:proxmox_dart_api_client/proxmox_dart_api_client.dart'
    as proxclient;
import 'package:pve_flutter_frontend/widgets/pve_storage_selector_widget.dart';
import 'package:pve_flutter_frontend/widgets/pve_vm_name_widget.dart';

class PveCreateVmWizard extends StatelessWidget {
  static const routeName = '/qemu/create';
  final List<ProxmoxStepChildWidget> stepWidgets = [
    ProxmoxStepChildWidget(
      title: "General",
      child: _General(),
    ),
    ProxmoxStepChildWidget(
      title: "OS",
      child: _OS(),
    ),
    ProxmoxStepChildWidget(
      title: "System",
      child: _System(),
    ),
    ProxmoxStepChildWidget(
      title: "Hard Disk",
      child: _HardDisk(),
    ),
    ProxmoxStepChildWidget(
      title: "CPU",
      child: _CPU(),
    ),
    ProxmoxStepChildWidget(
      title: "Memory",
      child: _Memory(),
    ),
    ProxmoxStepChildWidget(
      title: "Network",
      child: _Network(),
    )
  ];
  @override
  Widget build(BuildContext context) {
    final apiClient = Provider.of<proxclient.Client>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Create Virtual Machine"),
      ),
      body: MultiProvider(
        providers: [
          Provider<PveQemuCreateWizardBloc>(
            builder: (context) => PveQemuCreateWizardBloc(
                apiClient: apiClient, stepCount: stepWidgets.length)
              ..events.add(GoToStep(0)),
            dispose: (context, value) => value.dispose(),
          ),
        ],
        child: ProxmoxLayoutBuilder(
          builder: (context, layout) => Consumer<PveQemuCreateWizardBloc>(
            builder: (context, bloc, _) =>
                StreamBuilder<PveQemuCreateWizardState>(
                    stream: bloc.state,
                    initialData: bloc.state.value,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        print(bloc.qemu);
                        final state = snapshot.data;
                        final steps = getSteps(state);
                        if (state.currentStep == stepWidgets.length) {
                          Navigator.pop(context);
                          return null;
                        }

                        return Stepper(
                          type: layout != ProxmoxLayout.slim
                              ? StepperType.horizontal
                              : StepperType.vertical,
                          currentStep: state.currentStep,
                          steps: steps,
                          onStepContinue: state.currentStep < steps.length
                              ? () => bloc.inRequestStepChange
                                  .add(state.currentStep + 1)
                              : null,
                          onStepCancel: state.currentStep > 0
                              ? () {
                                  bloc.inRequestStepChange
                                      .add(state.currentStep - 1);
                                }
                              : null,
                          controlsBuilder: (BuildContext context,
                              {VoidCallback onStepContinue,
                              VoidCallback onStepCancel}) {
                            return StreamBuilder<bool>(
                                stream: bloc.outStepValidityChanged.distinct(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    var isValid = snapshot.data;
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        OutlineButton(
                                          onPressed: onStepCancel,
                                          child: const Text('BACK'),
                                        ),
                                        OutlineButton(
                                          onPressed:
                                              isValid ? onStepContinue : null,
                                          child: state.currentStep ==
                                                  bloc.stepCount - 1
                                              ? Text('CREATE')
                                              : Text('CONTINUE'),
                                        )
                                      ],
                                    );
                                  }
                                  return Container();
                                });
                          },
                        );
                      }
                      return Container();
                    }),
          ),
        ),
      ),
    );
  }

  StepState getStepState(int activeStep, int index) {
    if (activeStep == index) return StepState.editing;
    if (index < activeStep) return StepState.complete;
    if (index > activeStep) return StepState.indexed;
    return StepState.disabled;
  }

  List<Step> getSteps(PveQemuCreateWizardState currentState) {
    List<Step> steps = [];
    stepWidgets.asMap().forEach((index, widget) {
      steps.add(Step(
          title: Text(widget.title ?? ""),
          content: widget,
          isActive: index == currentState.currentStep,
          state: getStepState(currentState.currentStep, index)));
    });
    return steps;
  }
}

class ProxmoxStepChildWidget extends StatefulWidget {
  final String title;
  final Widget child;
  final List<Widget> summaryChilds;
  ProxmoxStepChildWidget({
    @required this.title,
    @required this.child,
    this.summaryChilds,
  });

  @override
  _ProxmoxStepChildWidgetState createState() => _ProxmoxStepChildWidgetState();
}

class _ProxmoxStepChildWidgetState extends State<ProxmoxStepChildWidget> {
  StreamSubscription<int> requestStepChangeSubscription;
  PveQemuCreateWizardBloc wizard;
  final _formKey = GlobalKey<FormState>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    wizard = Provider.of<PveQemuCreateWizardBloc>(context);

    // requestStepChangeSubscription =
    //     wizard.outRequestStepChange.listen((stepIndex) {
    //   print("do something important");
    //   wizard.clearValidation();
    //   wizard.events.add(GoToStep(stepIndex));
    // });
  }

  Widget build(BuildContext context) {
    final qemu = wizard.qemu;
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
          width: MediaQuery.of(context).size.width * 0.7,
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: 400),
            child: Form(
              key: _formKey,
              onChanged: () {
                print(_formKey.currentState.validate());
              },
              child: widget.child,
            ),
          )),
      Expanded(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: 400),
          child: Card(
            child: Column(
              children: <Widget>[
                Text("Summary"),
                ListTile(
                    title: Text("Node"), subtitle: Text(qemu?.node ?? "-")),
                ListTile(
                    title: Text("VM ID"),
                    subtitle: Text(qemu?.vmid?.toString() ?? "-")),
                ListTile(title: Text("CD"), subtitle: Text(qemu?.cdrom ?? "-")),
                ListTile(
                    title: Text("Guest OS"),
                    subtitle: Text(qemu?.ostype?.name ?? "-")),
                ListTile(
                    title: Text("SCSI Controller"),
                    subtitle: Text(qemu?.scsihw?.toString() ?? "-")),
                ListTile(
                    title: Text("Graphic Card"), subtitle: Text(null ?? "-")),
                ListTile(
                    title: Text("Qemu Guest Agent"),
                    subtitle: Text(null ?? "-")),
                ListTile(
                    title: Text("Disk"), subtitle: Text(qemu?.scsi0 ?? "-")),
                ListTile(
                    title: Text("Sockets | Cores"),
                    subtitle: Text(
                        '${qemu?.sockets ?? "-"} | ${qemu?.cores ?? "-"}')),
                ListTile(
                  title: Text("Memory"),
                  subtitle: Text('${qemu?.memory ?? "-"}'),
                ),
                ListTile(
                  title: Text("Network"),
                  subtitle: Text('${qemu?.net0 ?? "-"}'),
                )
              ],
            ),
          ),
        ),
      )
    ]);
  }

  @override
  void dispose() {
    requestStepChangeSubscription?.cancel();
    super.dispose();
  }
}

// STEPS
class _General extends StatefulWidget {
  const _General({Key key}) : super(key: key);
  @override
  _GeneralState createState() => _GeneralState();
}

class _GeneralState extends State<_General> {
  PveQemuCreateWizardBloc wizard;
  StreamSubscription<int> requestStepChangeSubscription;
  PveVmNameBloc vmNameBloc;
  PveNodeSelectorBloc nodeSelectorBloc;
  PveGuestIdSelectorBloc guestIdSelectorBloc;
  @override
  void initState() {
    super.initState();
    vmNameBloc = PveVmNameBloc();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    wizard = Provider.of<PveQemuCreateWizardBloc>(context);
    nodeSelectorBloc = PveNodeSelectorBloc(apiClient: wizard.apiClient);
    guestIdSelectorBloc = PveGuestIdSelectorBloc(apiClient: wizard.apiClient);

    wizard.addToValidation(vmNameBloc.state);
    wizard.addToValidation(guestIdSelectorBloc.state);
    wizard.addToValidation(nodeSelectorBloc.state);

    vmNameBloc.events.add(OnChange(wizard.qemu?.name ?? ""));

    requestStepChangeSubscription =
        wizard.outRequestStepChange.listen((stepIndex) {
      wizard.qemu = wizard.qemu?.rebuild((b) => b
            ..vmid = int.parse(guestIdSelectorBloc.state.value.value)
            ..node = nodeSelectorBloc.state.value.value.nodeName
            ..name = vmNameBloc.state.value.value) ??
          PveNodeQemuCreateModel((b) => b
            ..node = nodeSelectorBloc.state.value.value.nodeName
            ..vmid = int.parse(guestIdSelectorBloc.state.value.value)
            ..name = vmNameBloc.state.value.value);

      wizard.clearValidation();
      wizard.events.add(GoToStep(stepIndex));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Provider.value(
              value: nodeSelectorBloc..events.add(LoadNodesEvent()),
              child: PveNodeSelector(
                labelText: "Node",
              ),
            ),
            Provider.value(
              value: guestIdSelectorBloc..events.add(PrefetchId()),
              child: PveGuestIdSelector(
                labelText: "VM ID",
              ),
            ),
            Provider.value(
              value: vmNameBloc,
              child: PveVmNameWidget(),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    requestStepChangeSubscription?.cancel();
    vmNameBloc?.dispose();
    guestIdSelectorBloc?.dispose();
    nodeSelectorBloc?.dispose();
    super.dispose();
  }
}

class _OS extends StatefulWidget {
  @override
  _OSState createState() => _OSState();
}

class _OSState extends State<_OS> {
  PveQemuCreateWizardBloc wizard;
  StreamSubscription<int> requestStepChangeSubscription;
  PveGuestOsSelectorBloc gBloc;
  PveCdSelectorBloc cdBloc;

  @override
  void initState() {
    super.initState();
    gBloc = PveGuestOsSelectorBloc(fieldRequired: true);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    wizard = Provider.of<PveQemuCreateWizardBloc>(context);
    gBloc.events.add(ChangeOsType(wizard.qemu.ostype ?? OSType.l26));
    cdBloc = PveCdSelectorBloc();

    wizard.addToValidation(cdBloc.state);
    wizard.addToValidation(gBloc.state);

    requestStepChangeSubscription =
        wizard.outRequestStepChange.listen((stepIndex) {
      wizard.qemu = wizard.qemu?.rebuild((b) => b
        ..cdrom = cdBloc.state.value.file
        ..media = cdBloc.state.value.value
        ..ostype = gBloc.state.value.value);

      wizard.clearValidation();
      wizard.events.add(GoToStep(stepIndex));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Provider.value(
              value: cdBloc,
              child: PveCdSelector(),
            ),
            Provider.value(
              value: gBloc,
              child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 200),
                  child: PveGuestOsSelector()),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    requestStepChangeSubscription?.cancel();
    gBloc?.dispose();
    cdBloc?.dispose();
    super.dispose();
  }
}

class _System extends StatefulWidget {
  @override
  _SystemState createState() => _SystemState();
}

class _SystemState extends State<_System> {
  PveQemuCreateWizardBloc wizard;
  StreamSubscription<int> requestStepChangeSubscription;

  ScsiControllerModel scsiHwModel;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    wizard = Provider.of<PveQemuCreateWizardBloc>(context);
    //TODO add validation logic
    wizard.inStepValidityChanged.add(true);
    requestStepChangeSubscription =
        wizard.outRequestStepChange.listen((stepIndex) {
      wizard.qemu = wizard.qemu?.rebuild((b) => b..scsihw = scsiHwModel);

      wizard.clearValidation();
      wizard.events.add(GoToStep(stepIndex));
    });

    scsiHwModel = wizard.qemu.scsihw ?? ScsiControllerModel.virtioScsiPci;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            DropdownButtonFormField(
              decoration: InputDecoration(
                labelText: "SCSI Controller",
                helperText: ' ',
              ),
              items: ScsiControllerModel.values
                  .map((item) =>
                      DropdownMenuItem(value: item, child: Text(item.name)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  scsiHwModel = value;
                });
              },
              value: scsiHwModel,
            ),
            DropdownButtonFormField(
              decoration: InputDecoration(
                labelText: "Graphic Card",
                helperText: ' ',
              ),
            ),
            //TODO format of this api parameter is actually string....needs a custom parser
            CheckboxListTile(
              title: Text("Qemu Guest Agent"),
              value: false,
              onChanged: null,
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    requestStepChangeSubscription?.cancel();
    super.dispose();
  }
}

class _HardDisk extends StatefulWidget {
  @override
  _HardDiskState createState() => _HardDiskState();
}

class _HardDiskState extends State<_HardDisk> {
  PveQemuCreateWizardBloc wizard;
  StreamSubscription<int> requestStepChangeSubscription;
  TextEditingController diskSizeController;
  PveStorageSelectorBloc storageSelectorBloc;
  @override
  void initState() {
    super.initState();
    diskSizeController = TextEditingController(text: '0.01');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final apiClient = Provider.of<proxclient.Client>(context);

    wizard = Provider.of<PveQemuCreateWizardBloc>(context);
    storageSelectorBloc = PveStorageSelectorBloc(
        apiClient: apiClient,
        targetNode: wizard.qemu.node,
        content: PveStorageContentType.images)
      ..events.add(LoadStoragesEvent());
    wizard.addToValidation(storageSelectorBloc.state);
    requestStepChangeSubscription =
        wizard.outRequestStepChange.listen((stepIndex) {
      wizard.qemu = wizard.qemu?.rebuild((b) => b
        ..scsi0 =
            '${storageSelectorBloc.latestState.value.id}:${diskSizeController.text}');

      wizard.clearValidation();
      wizard.events.add(GoToStep(stepIndex));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Row(crossAxisAlignment: CrossAxisAlignment.end, children: <Widget>[
              Expanded(
                child: DropdownButtonFormField(
                  decoration: InputDecoration(
                    labelText: "Bus",
                    helperText: ' ',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Container(
                  width: 50,
                  child: TextFormField(
                    decoration:
                        InputDecoration(labelText: 'Device', helperText: ' '),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly
                    ],
                    autovalidate: true,
                  ),
                ),
              ),
            ]),
            Provider.value(
              value: storageSelectorBloc,
              child: PveStorageSelector(),
            ),
            TextFormField(
              decoration: InputDecoration(
                  labelText: 'Disk Size (GiB)', helperText: ' '),
              keyboardType:
                  TextInputType.numberWithOptions(decimal: true, signed: false),
              inputFormatters: [
                WhitelistingTextInputFormatter(RegExp(r'\d+\.?(\d{1,2})?'))
              ],
              autovalidate: true,
              controller: diskSizeController,
              validator: (String value) {
                if (value.isNotEmpty) {
                  final size = double.parse(value);
                  final maxSize = 131072; // 128*1024

                  if (size > maxSize) {
                    return "Max size ${maxSize.toString()}";
                  }

                  if (size < 0.001) {
                    return "Min size 0.001";
                  }
                } else {
                  return "Required";
                }
              },
            ),
            DropdownButtonFormField(
              decoration: InputDecoration(
                labelText: "Format",
                helperText: ' ',
              ),
            ),
            DropdownButtonFormField(
              decoration: InputDecoration(
                labelText: "Cache",
                helperText: ' ',
              ),
            ),
            CheckboxListTile(
              title: Text("Discard"),
              value: false,
              onChanged: null,
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    requestStepChangeSubscription?.cancel();
    storageSelectorBloc?.dispose();
    diskSizeController?.dispose();
    super.dispose();
  }
}

class _CPU extends StatefulWidget {
  @override
  _CPUState createState() => _CPUState();
}

class _CPUState extends State<_CPU> {
  PveQemuCreateWizardBloc wizard;
  StreamSubscription<int> requestStepChangeSubscription;
  TextEditingController socketTextController;
  TextEditingController coreTextController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    wizard = Provider.of<PveQemuCreateWizardBloc>(context);
    socketTextController = TextEditingController(text: '1');
    coreTextController = TextEditingController(text: '2');
    //TODO add validation logic
    wizard.inStepValidityChanged.add(true);
    requestStepChangeSubscription =
        wizard.outRequestStepChange.listen((stepIndex) {
      wizard.qemu = wizard.qemu?.rebuild((b) => b
        ..sockets = int.parse(socketTextController.text)
        ..cores = int.parse(coreTextController.text));

      wizard.clearValidation();
      wizard.events.add(GoToStep(stepIndex));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration:
                  InputDecoration(labelText: 'Sockets', helperText: ' '),
              keyboardType: TextInputType.number,
              inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
              autovalidate: true,
              controller: socketTextController,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Cores', helperText: ' '),
              keyboardType: TextInputType.number,
              inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
              autovalidate: true,
              controller: coreTextController,
            ),
            DropdownButtonFormField(
              decoration: InputDecoration(
                labelText: "Type",
                helperText: ' ',
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    requestStepChangeSubscription?.cancel();
    socketTextController?.dispose();
    coreTextController?.dispose();
    super.dispose();
  }
}

class _Memory extends StatefulWidget {
  @override
  _MemoryState createState() => _MemoryState();
}

class _MemoryState extends State<_Memory> {
  PveQemuCreateWizardBloc wizard;
  StreamSubscription<int> requestStepChangeSubscription;
  TextEditingController memoryTextController;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    wizard = Provider.of<PveQemuCreateWizardBloc>(context);
    memoryTextController = TextEditingController(text: '2048');
    //TODO add validation logic
    wizard.inStepValidityChanged.add(true);
    requestStepChangeSubscription =
        wizard.outRequestStepChange.listen((stepIndex) {
      wizard.qemu = wizard.qemu
          ?.rebuild((b) => b..memory = int.parse(memoryTextController.text));

      wizard.clearValidation();
      wizard.events.add(GoToStep(stepIndex));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration:
                  InputDecoration(labelText: 'Memory (MiB)', helperText: ' '),
              keyboardType: TextInputType.number,
              inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
              autovalidate: true,
              controller: memoryTextController,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    requestStepChangeSubscription?.cancel();
    memoryTextController?.dispose();
    super.dispose();
  }
}

class _Network extends StatefulWidget {
  @override
  _NetworkState createState() => _NetworkState();
}

class _NetworkState extends State<_Network> {
  PveQemuCreateWizardBloc wizard;
  StreamSubscription<int> requestStepChangeSubscription;
  PveBridgeSelectorBloc bridgeBloc;
  bool firewall;
  String interfaceModel;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final apiClient = Provider.of<proxclient.Client>(context);
    wizard = Provider.of<PveQemuCreateWizardBloc>(context);
    bridgeBloc = PveBridgeSelectorBloc(
        apiClient: apiClient, targetNode: wizard.qemu.node)
      ..events.add(LoadBridgesEvent());
    firewall = true;
    interfaceModel = 'virtio';
    wizard.addToValidation(bridgeBloc.state);
    requestStepChangeSubscription =
        wizard.outRequestStepChange.listen((stepIndex) {
      wizard.qemu = wizard.qemu?.rebuild((b) => b
        ..net0 =
            '$interfaceModel,bridge=${bridgeBloc.latestState.value.iface},firewall=${firewall ? 1 : 0}');

      wizard.clearValidation();
      wizard.events.add(GoToStep(stepIndex));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            CheckboxListTile(
              title: Text("No network device"),
              value: false,
              onChanged: null,
            ),
            Provider.value(
              value: bridgeBloc,
              child: PveBridgeSelector(
                labelText: "Bridge",
              ),
            ),
            PveNetworkInterfaceModelSelector(
              onChange: (String text) => interfaceModel = text,
              initialSelection: interfaceModel,
            ),
            TextFormField(
              decoration:
                  InputDecoration(labelText: 'VLAN Tag', helperText: ' '),
              keyboardType: TextInputType.number,
              inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
              autovalidate: true,
            ),
            TextFormField(
              decoration:
                  InputDecoration(labelText: 'MAC address', helperText: ' '),
              autovalidate: true,
            ),
            CheckboxListTile(
              title: Text("Firewall"),
              value: firewall,
              onChanged: (value) {
                setState(() {
                  firewall = value;
                });
              },
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    requestStepChangeSubscription?.cancel();
    bridgeBloc?.dispose();
    super.dispose();
  }
}
