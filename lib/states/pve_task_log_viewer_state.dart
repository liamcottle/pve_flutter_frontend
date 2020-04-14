import 'package:built_value/built_value.dart';
import 'package:proxmox_dart_api_client/proxmox_dart_api_client.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/serializer.dart';
import 'package:pve_flutter_frontend/states/pve_base_state.dart';

part 'pve_task_log_viewer_state.g.dart';

abstract class PveTaskLogViewerState with PveBaseState
    implements Built<PveTaskLogViewerState, PveTaskLogViewerStateBuilder> {
  // Fields
  String get nodeID;

  @nullable
  String get upid;
  @nullable
  PveTaskLogResponse get log;
  @nullable
  PveTaskLogStatus get status;
  PveTaskLogViewerState._();

  factory PveTaskLogViewerState(
          [void Function(PveTaskLogViewerStateBuilder) updates]) =
      _$PveTaskLogViewerState;

  factory PveTaskLogViewerState.init(
    String nodeID, {String upid}
  ) =>
      PveTaskLogViewerState((b) => b
        //base
        ..errorMessage = ''
        ..isBlank = true
        ..isLoading = false
        ..isSuccess = false
        //class
        ..nodeID = nodeID
        ..upid = upid
);
}
