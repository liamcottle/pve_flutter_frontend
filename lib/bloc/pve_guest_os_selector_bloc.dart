import 'package:pve_flutter_frontend/bloc/proxmox_base_bloc.dart';
import 'package:pve_flutter_frontend/states/proxmox_form_field_state.dart';
import 'package:pve_flutter_frontend/states/pve_qemu_create_wizard_state.dart';

class PveGuestOsSelectorBloc
    extends ProxmoxBaseBloc<PveGuestOsSelectorEvent, PveGuestOsSelectorState> {
  bool fieldRequired;

  Map<OSType, Map<String, String>> osChoices = {
    OSType.l26: {'desc': '5.x - 2.6 Kernel', 'type': 'Linux'},
    OSType.l24: {'desc': '2.4 Kernel', 'type': 'Linux'},
    OSType.win10: {'desc': '10/2016/2019', 'type': 'Microsoft Windows'},
    OSType.win8: {'desc': '8.x/2012/2012r2', 'type': 'Microsoft Windows'},
    OSType.win7: {'desc': '7/2008r2', 'type': 'Microsoft Windows'},
    OSType.w2k8: {'desc': 'Vista/2008', 'type': 'Microsoft Windows'},
    OSType.wxp: {'desc': 'XP/2003', 'type': 'Microsoft Windows'},
    OSType.w2k: {'desc': '2000', 'type': 'Microsoft Windows'},
    OSType.solaris: {'desc': '-', 'type': 'Solaris Kernel'},
    OSType.other: {'desc': '-', 'type': 'Other'},
  };

  @override
  PveGuestOsSelectorState get initialState => PveGuestOsSelectorState();

  PveGuestOsSelectorBloc({this.fieldRequired = false});

  @override
  Stream<PveGuestOsSelectorState> processEvents(
      PveGuestOsSelectorEvent event) async* {

    if (event is ChangeOsType) {
      if (event.type == null && fieldRequired) {
        yield latestState.copyWith(value: event.type, errorText: "Required");
      } else {
        yield latestState.copyWith(value: event.type, errorText: null);
      }

    }
  }
}

class PveGuestOsSelectorState extends PveFormFieldState<OSType> {
  PveGuestOsSelectorState({OSType value, String errorText})
      : super(value: value, errorText: errorText);

  PveGuestOsSelectorState copyWith(
      {String os, OSType value, String errorText}) {
    return PveGuestOsSelectorState(
        value: value ?? this.value, errorText: errorText ?? this.errorText);
  }
}

abstract class PveGuestOsSelectorEvent {}

class ChangeOsType extends PveGuestOsSelectorEvent {
  final OSType type;

  ChangeOsType(this.type);
}
