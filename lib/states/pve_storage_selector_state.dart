import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:proxmox_dart_api_client/proxmox_dart_api_client.dart';
import 'package:pve_flutter_frontend/states/pve_base_state.dart';

part 'pve_storage_selector_state.g.dart';

abstract class PveStorageSelectorState
    with PveBaseState
    implements Built<PveStorageSelectorState, PveStorageSelectorStateBuilder> {
  // Fields
  BuiltList<PveNodesStorageModel> get storages;
  bool get enabledOnly;
  String get nodeID;

  @nullable
  String get storage;
  @nullable
  PveNodesStorageModel get selected;
  @nullable
  PveStorageContentType get content;

  PveStorageSelectorState._();

  factory PveStorageSelectorState(
          [void Function(PveStorageSelectorStateBuilder) updates]) =
      _$PveStorageSelectorState;

  factory PveStorageSelectorState.init({
    String nodeID = 'localhost',
  }) =>
      PveStorageSelectorState((b) => b
        //base
        ..errorMessage = ''
        ..isBlank = true
        ..isLoading = false
        ..isSuccess = false
        //class
        ..nodeID = nodeID
        ..enabledOnly = true);
}
