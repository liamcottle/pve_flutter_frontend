import 'dart:async';

import 'package:meta/meta.dart';
import 'package:proxmox_dart_api_client/proxmox_dart_api_client.dart';
import 'package:pve_flutter_frontend/bloc/proxmox_base_bloc.dart';
import 'package:pve_flutter_frontend/states/pve_migrate_state.dart';
import 'package:pve_flutter_frontend/utils/renderers.dart';

class PveMigrateBloc extends ProxmoxBaseBloc<PveMigrateEvent, PveMigrateState> {
  final ProxmoxApiClient apiClient;
  final String guestID;
  final PveMigrateState init;
  PveMigrateBloc(
      {required this.apiClient, required this.guestID, required this.init});

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
        yield* checkQemuPreconditons();
      }

      if (latestState.guestType == 'lxc') {
        final status =
            await (apiClient.getLxcStatusCurrent(latestState.nodeID, guestID) as FutureOr<PveNodesLxcStatusModel>);
        final running = status.getLxcStatus() == PveResourceStatusType.running;
        yield latestState.rebuild((b) => b
          ..lxcPreconditions
              .replace(PveNodesLxcMigrateModel((b) => b..running = running)));
      }
    }
    if (event is StartMigration) {
      if (latestState.targetNodeID == null ||
          latestState.targetNodeID!.isEmpty) {
        yield* showError("Target is mandatory");
        return;
      }

      if (latestState.targetNodeID == latestState.nodeID) {
        yield* showError("Target can't be source node");
        return;
      }

      if (latestState.guestType == 'qemu') {
        try {
          final online = latestState.mode == PveMigrationMode.online;

          final mtask = await apiClient.qemuMigrate(
              latestState.nodeID, guestID, latestState.targetNodeID!,
              online: online);
          yield PveMigrateState.init(latestState.nodeID, latestState.guestType)
              .rebuild((b) => b..taskUPID = mtask);
        } on ProxmoxApiException catch (e) {
          yield* showError(e.toString());
        }
      }

      if (latestState.guestType == 'lxc') {
        try {
          final restart = latestState.mode == PveMigrationMode.restart;
          final mtask = await apiClient.lxcMigrate(
              latestState.nodeID, guestID, latestState.targetNodeID!,
              restart: restart);
          yield PveMigrateState.init(latestState.nodeID, latestState.guestType)
              .rebuild((b) => b..taskUPID = mtask);
        } on ProxmoxApiException catch (e) {
          yield* showError(e.toString());
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

  Stream<PveMigrateState> checkQemuPreconditons() async* {
    final qPreconditions = await (apiClient.getMigratePreconditions(
      latestState.nodeID,
      guestID,
      migrationTarget: latestState.targetNodeID,
    ) as FutureOr<PveNodesQemuMigrate>);

    var preconditions = <PveMigrateCondition>[];

    qPreconditions.localDisks!.forEach((d) {
      var disk = d.asMap;
      if (disk['cdrom'] == 1) {
        if (disk['volid'].contains('vm-' + guestID + '-cloudinit')) {
          if (qPreconditions.running!) {
            preconditions.add(PveMigrateCondition((b) => b
              ..severity = PveMigrateSeverity.error
              ..message =
                  "Can't live migrate VM with local cloudinit disk, use shared storage instead"));
          } else {
            return;
          }
        } else {
          preconditions.add(PveMigrateCondition((b) => b
            ..severity = PveMigrateSeverity.error
            ..message = "Can't migrate VM with local CD/DVD"));
        }
      } else {
        preconditions.add(PveMigrateCondition((b) => b
          ..severity = PveMigrateSeverity.warning
          ..message = "Migration with local disk might take long: " +
              Renderers.formatSize(disk['size'])));
      }
    });

    preconditions.sort((a, b) => a.severity.name.compareTo(b.severity.name));

    yield latestState.rebuild((b) => b
      ..preconditions.replace(preconditions)
      ..qemuPreconditions.replace(qPreconditions));
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
  final String? targetNodeID;

  MigrationTargetChanged(this.targetNodeID);
}

class SourceNodeChanged extends PveMigrateEvent {
  final String? nodeID;

  SourceNodeChanged(this.nodeID);
}
