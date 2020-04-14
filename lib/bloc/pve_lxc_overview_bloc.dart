import 'dart:async';

import 'package:meta/meta.dart';
import 'package:proxmox_dart_api_client/proxmox_dart_api_client.dart';
import 'package:pve_flutter_frontend/bloc/proxmox_base_bloc.dart';
import 'package:pve_flutter_frontend/states/pve_lxc_overview_state.dart';

class PveLxcOverviewBloc
    extends ProxmoxBaseBloc<PveLxcOverviewEvent, PveLxcOverviewState> {
  final ProxmoxApiClient apiClient;
  final String guestID;
  final PveLxcOverviewState init;
  Timer updateTimer;

  PveLxcOverviewState get initialState => init;

  PveLxcOverviewBloc({
    @required this.guestID,
    @required this.apiClient,
    @required this.init,
  });

  @override
  void doOnListen() {
    updateTimer = Timer.periodic(
        Duration(seconds: 4), (timer) => events.add(UpdateLxcStatus()));
  }

  @override
  void doOnCancel() {
    if (!hasListener) {
      updateTimer?.cancel();
    }
  }

  Stream<PveLxcOverviewState> processEvents(PveLxcOverviewEvent event) async* {
    if (event is UpdateLxcStatus) {
      final status =
          await apiClient.getLxcStatusCurrent(latestState.nodeID, guestID);
      yield latestState.rebuild((b) => b..currentStatus.replace(status));

      final config = await apiClient.getLxcConfig(latestState.nodeID, guestID,
          current: true);
      yield latestState.rebuild((b) => b..config.replace(config));

      final rrdData = (await apiClient.getNodeQemuRRDdata(
          latestState.nodeID, guestID, PveRRDTimeframeType.hour));
      yield latestState.rebuild((b) => b..rrdData.replace(rrdData));
    }
    if (event is PerformLxcAction) {
      var param = <String, String>{};

      await apiClient.doResourceAction(
          latestState.nodeID, guestID, 'lxc', event.action,
          parameters: param);

      yield latestState;
    }
    if (event is Migration) {
      if (!event.inProgress) {
        yield latestState.rebuild((b) => b..nodeID = event.newNodeID);
      }
    }
  }
}

abstract class PveLxcOverviewEvent {}

class UpdateLxcStatus extends PveLxcOverviewEvent {}

class PerformLxcAction extends PveLxcOverviewEvent {
  final PveClusterResourceAction action;

  PerformLxcAction(this.action);
}

class Migration extends PveLxcOverviewEvent {
  final bool inProgress;
  final String newNodeID;

  Migration(this.inProgress, this.newNodeID);
}
