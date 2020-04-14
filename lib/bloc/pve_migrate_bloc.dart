import 'dart:async';

import 'package:meta/meta.dart';
import 'package:proxmox_dart_api_client/proxmox_dart_api_client.dart';
import 'package:pve_flutter_frontend/bloc/proxmox_base_bloc.dart';
import 'package:pve_flutter_frontend/states/pve_migrate_state.dart';

class PveMigrateBloc extends ProxmoxBaseBloc<PveMigrateEvent, PveMigrateState> {
  final ProxmoxApiClient apiClient;
  final String guestID;
  final PveMigrateState init;
  PveMigrateBloc(
      {@required this.apiClient, @required this.guestID, @required this.init});

  @override
  PveMigrateState get initialState => init;

  @override
  void doOnListen() {}

  @override
  void doOnCancel() {}

  @override
  Stream<PveMigrateState> processEvents(event) async* {
    if (event is CheckMigratePreconditions) {
      if (latestState.guestType == 'qemu') {
        final preconditions = await apiClient.getMigratePreconditions(
            latestState.nodeID, guestID,
            migrationTarget: latestState.targetNodeID);
        yield latestState
            .rebuild((b) => b..qemuPreconditions.replace(preconditions));
      }
    }
    if (event is StartMigration) {
      if (latestState.targetNodeID == null ||
          latestState.targetNodeID.isEmpty) {
        yield* showError("Target is mandatory");
        return;
      }

      if (latestState.targetNodeID == latestState.nodeID) {
        yield* showError("Target can't be source node");
        return;
      }
      if (latestState.guestType == 'qemu') {
        try {
          final mtask = await apiClient.qemuMigrate(
              latestState.nodeID, guestID, latestState.targetNodeID);
          yield PveMigrateState.init(latestState.nodeID, latestState.guestType)
              .rebuild((b) => b..taskUPID = mtask);
        } on ProxmoxApiException catch (e) {
          print(e.toString());
        }
      }

      if (latestState.guestType == 'lxc') {
        try {
          final mtask = await apiClient.lxcMigrate(
              latestState.nodeID, guestID, latestState.targetNodeID);
          yield PveMigrateState.init(latestState.nodeID, latestState.guestType)
              .rebuild((b) => b..taskUPID = mtask);
        } on ProxmoxApiException catch (e) {
          print(e.toString());
        }
      }
    }

    if (event is UpdateMigrationStatus) {
      yield latestState.rebuild((b) => b..inProgress = event.inProgress);
    }

    if (event is MigrationTargetChanged) {
      yield latestState.rebuild((b) => b..targetNodeID = event.targetNodeID);
    }

    if (event is SourceNodeChanged) {
      yield latestState.rebuild((b) => b.nodeID = event.nodeID);
    }
  }

  Stream<PveMigrateState> showError(String errorText) async* {
    yield latestState.rebuild((b) => b..errorMessage = errorText);
    yield latestState.rebuild((b) => b..errorMessage = "");
  }
}

abstract class PveMigrateEvent {}

class CheckMigratePreconditions extends PveMigrateEvent {}

class StartMigration extends PveMigrateEvent {}

class UpdateMigrationStatus extends PveMigrateEvent {
  final bool inProgress;

  UpdateMigrationStatus(this.inProgress);
}

class MigrationTargetChanged extends PveMigrateEvent {
  final String targetNodeID;

  MigrationTargetChanged(this.targetNodeID);
}

class SourceNodeChanged extends PveMigrateEvent {
  final String nodeID;

  SourceNodeChanged(this.nodeID);
}
