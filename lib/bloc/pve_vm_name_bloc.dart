import 'package:pve_flutter_frontend/bloc/proxmox_base_bloc.dart';
import 'package:pve_flutter_frontend/states/proxmox_form_field_state.dart';
import 'package:pve_flutter_frontend/utils/validators.dart';

class PveVmNameBloc extends ProxmoxBaseBloc<PveVmNameEvent, PveVmNameState> {
  @override
  PveVmNameState get initialState => PveVmNameState();

  @override
  Stream<PveVmNameState> processEvents(PveVmNameEvent event) async* {
    if (event is OnChange) {
      if (!Validators.isValidDnsName(event.name) && event.name.isNotEmpty) {
        yield PveVmNameState(value: event.name, errorText: "Enter valid name");
      } else {
        yield PveVmNameState(value: event.name);
      }
    }
  }
}

abstract class PveVmNameEvent {}

class OnChange extends PveVmNameEvent {
  final String name;
  OnChange(this.name);
}

class PveVmNameState extends PveFormFieldState<String> {
  PveVmNameState({String value, String errorText})
      : super(value: value, errorText: errorText);
}
