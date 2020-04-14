import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:proxmox_dart_api_client/proxmox_dart_api_client.dart';
import 'package:pve_flutter_frontend/states/pve_base_state.dart';
part 'pve_task_log_state.g.dart';

abstract class PveTaskLogState
    with PveBaseState
    implements Built<PveTaskLogState, PveTaskLogStateBuilder> {
  String get nodeID;

  int get limit;

  int get total;

  String get source;

  bool get onlyErrors;

  @nullable
  String get userFilter;
  @nullable
  String get typeFilter;
  @nullable
  String get guestID;

  BuiltList<PveClusterTasksModel> get tasks;

  PveTaskLogState._();

  factory PveTaskLogState.init(
    String nodeID,
  ) =>
      PveTaskLogState((b) => b
        //base
        ..errorMessage = ''
        ..isBlank = true
        ..isLoading = false
        ..isSuccess = false
        //class
        ..nodeID = nodeID
        ..onlyErrors = false
        ..source = 'all'
        ..total = 0
        ..limit = 50);

  factory PveTaskLogState([void Function(PveTaskLogStateBuilder) updates]) =
      _$PveTaskLogState;
}
