import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proxmox_dart_api_client/proxmox_dart_api_client.dart';
import 'package:pve_flutter_frontend/bloc/pve_migrate_bloc.dart';
import 'package:pve_flutter_frontend/bloc/pve_node_selector_bloc.dart';
import 'package:pve_flutter_frontend/bloc/pve_resource_bloc.dart';
import 'package:pve_flutter_frontend/bloc/pve_task_log_viewer_bloc.dart';
import 'package:pve_flutter_frontend/states/pve_migrate_state.dart';
import 'package:pve_flutter_frontend/states/pve_resource_state.dart';
import 'package:pve_flutter_frontend/states/pve_task_log_viewer_state.dart';
import 'package:pve_flutter_frontend/widgets/proxmox_stream_listener.dart';

class PveMigrateStreamConnector extends StatelessWidget {
  final Widget child;

  const PveMigrateStreamConnector({Key key, this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final mBloc = Provider.of<PveMigrateBloc>(context);
    final nbloc = Provider.of<PveNodeSelectorBloc>(context);
    final tBloc = Provider.of<PveTaskLogViewerBloc>(context);
    final gBloc = Provider.of<PveResourceBloc>(context);

    return StreamListener<PveResourceState>(
      stream: gBloc.state,
      onStateChange: (globalResourceState) {
        final mState = mBloc.latestState;
        final guest = globalResourceState
            .resourceByID('${mState.guestType}/${mBloc.guestID}');
        if (guest.node != mState.nodeID) {
          mBloc.events.add(SourceNodeChanged(guest.node));
          nbloc.events.add(LoadNodesEvent());
          nbloc.events.add(UpdateDisallowedNodes(<String>{guest.node}));
          mBloc.events.add(CheckMigratePreconditions());
        }
      },
      child: StreamListener<PveTaskLogViewerState>(
        stream: tBloc.state,
        onStateChange: (state) {
          if ((state.status?.status == PveTaskLogStatusType.running) !=
              mBloc.latestState.inProgress) {
            mBloc.events.add(UpdateMigrationStatus(
                state.status?.status == PveTaskLogStatusType.running));
          }
        },
        child: StreamListener<PveMigrateState>(
          stream: mBloc.state.distinct(),
          onStateChange: (state) {
            if (state.taskUPID != tBloc.latestState.upid) {
              tBloc.events.add(SetTaskUPID(state.taskUPID));
            }

            if (state.qemuPreconditions?.allowedNodes !=
                mBloc.penultimate?.qemuPreconditions?.allowedNodes) {
              nbloc.events.add(UpdateAllowedNodes(
                  Set.from(state.qemuPreconditions.allowedNodes)));
            }
          },
          child: child,
        ),
      ),
    );
  }
}
