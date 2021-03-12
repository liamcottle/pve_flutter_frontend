import 'package:rxdart/streams.dart' show ValueStreamExtensions;
import 'package:pve_flutter_frontend/bloc/proxmox_base_bloc.dart';
import 'package:pve_flutter_frontend/states/proxmox_form_field_state.dart';
import 'package:proxmox_dart_api_client/proxmox_dart_api_client.dart';

class PveCdSelectorBloc
    extends ProxmoxBaseBloc<PveCdSelectorEvent, PveCdSelectorState> {
  @override
  PveCdSelectorState get initialState =>
      PveCdSelectorState(CdType.iso, 'Choose file');

  PveCdSelectorBloc();

  @override
  Stream<PveCdSelectorState> processEvents(PveCdSelectorEvent event) async* {
    if (event is ChangeValue) {
      if (event.value == CdType.iso &&
          (state.value.file == null || state.value.file.isEmpty)) {
        yield PveCdSelectorState(event.value, "Choose file");
      } else {
        yield PveCdSelectorState(event.value, null);
      }
    }

    if (event is FileSelected) {
      yield PveCdSelectorState(state.value.value, null, file: event.volid);
    }
  }
}

abstract class PveCdSelectorEvent {}

class ChangeValue extends PveCdSelectorEvent {
  final CdType value;
  ChangeValue(this.value);
}

class FileSelected extends PveCdSelectorEvent {
  final String volid;
  FileSelected(this.volid);
}

class PveCdSelectorState extends PveFormFieldState<CdType> {
  final String file;
  PveCdSelectorState(CdType value, String error, {this.file})
      : super(value: value, errorText: error);
}
