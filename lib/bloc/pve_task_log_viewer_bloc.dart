import 'dart:async';

import 'package:meta/meta.dart';
import 'package:proxmox_dart_api_client/proxmox_dart_api_client.dart';
import 'package:pve_flutter_frontend/bloc/proxmox_base_bloc.dart';
import 'package:pve_flutter_frontend/states/pve_task_log_viewer_state.dart';

class PveTaskLogViewerBloc
    extends ProxmoxBaseBloc<PveTaskLogViewerEvent, PveTaskLogViewerState> {
  final ProxmoxApiClient apiClient;
  final PveTaskLogViewerState init;
  @override
  PveTaskLogViewerState get initialState => init;

  PveTaskLogViewerBloc({@required this.apiClient, @required this.init});

  Timer updateStatus;
  Timer updateLog;

  @override
  void doOnListen() {
    updateStatus = Timer.periodic(Duration(seconds: 1), (timer) {
      if (latestState.upid != null) {
        events.add(UpdateStatus());
        if (latestState.status?.status == PveTaskLogStatusType.stopped) {
          updateStatus.cancel();
        }
      }
    });

    updateLog = Timer.periodic(Duration(seconds: 1), (timer) {
      if (latestState.upid != null) {
        events.add(UpdateLog());
        if (latestState.status?.status == PveTaskLogStatusType.stopped) {
          updateStatus.cancel();
        }
      }
    });
  }

  @override
  void doOnCancel() {
    if (!hasListener) {
      updateStatus?.cancel();
      updateLog?.cancel();
    }
  }

  @override
  Stream<PveTaskLogViewerState> processEvents(
      PveTaskLogViewerEvent event) async* {
    yield latestState.rebuild((b) => b..isBlank = false);
    if (event is SetTaskUPID) {
      yield latestState.rebuild((b) => b..upid = event.upid);
    }
    if (event is UpdateStatus) {
      yield latestState.rebuild((b) => b..isLoading = true);

      final taskStatus = await apiClient.getNodeTaskStatus(
          latestState.nodeID, latestState.upid);
      yield latestState.rebuild((b) => b
        ..status.replace(taskStatus)
        ..isLoading = false);
    }
    if (event is UpdateLog) {
      yield latestState.rebuild((b) => b..isLoading = true);

      final taskLog =
          await apiClient.getNodeTaskLog(latestState.nodeID, latestState.upid);
      yield latestState.rebuild((b) => b
        ..log.replace(taskLog)
        ..isLoading = false);
    }
  }
}

class PveTaskLogViewerEvent {}

class SetTaskUPID extends PveTaskLogViewerEvent {
  final String upid;

  SetTaskUPID(this.upid);
}

class UpdateStatus extends PveTaskLogViewerEvent {}

class UpdateLog extends PveTaskLogViewerEvent {}
