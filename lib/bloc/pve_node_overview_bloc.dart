import 'dart:async';

import 'package:meta/meta.dart';
import 'package:proxmox_dart_api_client/proxmox_dart_api_client.dart';
import 'package:pve_flutter_frontend/bloc/proxmox_base_bloc.dart';
import 'package:pve_flutter_frontend/states/pve_node_overview_state.dart';

class PveNodeOverviewBloc
    extends ProxmoxBaseBloc<PveNodeOverviewEvent, PveNodeOverviewState> {
  final ProxmoxApiClient apiClient;
  final String nodeID;
  final PveNodeOverviewState init;
  @override
  PveNodeOverviewState get initialState => init;

  PveNodeOverviewBloc(
      {@required this.apiClient, @required this.nodeID, @required this.init});

  Timer sTimer;
  @override
  void doOnListen() {
    sTimer = Timer.periodic(
        Duration(seconds: 4), (timer) => events.add(UpdateNodeStatus()));
  }

  @override
  void doOnCancel() {
    if (!hasListener) {
      sTimer?.cancel();
    }
  }

  @override
  Stream<PveNodeOverviewState> processEvents(
      PveNodeOverviewEvent event) async* {
    if (event is UpdateNodeStatus) {
      final status = await apiClient.getNodeStatus(nodeID);
      yield latestState.rebuild((b) => b..status.replace(status));
      final rrdData =
          await apiClient.getNodeRRDdata(nodeID, PveRRDTimeframeType.hour);
      yield latestState.rebuild((b) => b..rrdData.replace(rrdData));
      final services = await apiClient.getNodeServices(nodeID);
      yield latestState.rebuild((b) => b..services.replace(services));
      final updates = await apiClient.getNodeAptUpdate(nodeID);
      yield latestState.rebuild((b) => b..updates.replace(updates));
      final disks = await apiClient.getNodeDisksList(nodeID);
      yield latestState.rebuild((b) => b..disks.replace(disks));
    }
  }
}

abstract class PveNodeOverviewEvent {}

class UpdateNodeStatus extends PveNodeOverviewEvent {}
