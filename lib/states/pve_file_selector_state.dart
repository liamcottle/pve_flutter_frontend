import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:proxmox_dart_api_client/proxmox_dart_api_client.dart';
import 'package:pve_flutter_frontend/states/pve_base_state.dart';

part 'pve_file_selector_state.g.dart';

abstract class PveFileSelectorState
    with PveBaseState
    implements Built<PveFileSelectorState, PveFileSelectorStateBuilder> {
  // Fields
  BuiltList<PveNodesStorageContentModel> get content;
  bool get gridView;
  bool get search;
  String get nodeID;
  @nullable
  String get volidFilter;
  @nullable
  String get storageID;
  @nullable
  PveStorageContentType get fileType;
  @nullable
  int get guestID;

  PveFileSelectorState._();

  factory PveFileSelectorState(
          [void Function(PveFileSelectorStateBuilder) updates]) =
      _$PveFileSelectorState;

  factory PveFileSelectorState.init({
    String nodeID = 'localhost',
  }) =>
      PveFileSelectorState((b) => b
        //base
        ..errorMessage = ''
        ..isBlank = true
        ..isLoading = false
        ..isSuccess = false
        //class
        ..nodeID = nodeID
        ..gridView = false
        ..search = false);
}
