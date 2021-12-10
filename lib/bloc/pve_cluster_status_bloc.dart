import 'dart:async';

import 'package:meta/meta.dart';
import 'package:pve_flutter_frontend/bloc/proxmox_base_bloc.dart';
import 'package:pve_flutter_frontend/states/pve_cluster_status_state.dart';
import 'package:proxmox_dart_api_client/proxmox_dart_api_client.dart';

class PveClusterStatusBloc
    extends ProxmoxBaseBloc<PveClusterStatusEvent, PveClusterStatusState> {
  final ProxmoxApiClient apiClient;
  final PveClusterStatusState init;
  PveClusterStatusState get initialState => init;
  Timer? updateTimer;

  @override
  void doOnListen() {
    updateTimer = Timer.periodic(
        Duration(seconds: 6), (timer) => events.add(UpdateClusterStatus()));
  }

  @override
  void doOnCancel() {
    if (!hasListener) {
      updateTimer?.cancel();
    }
  }

  PveClusterStatusBloc({required this.apiClient, required this.init});

  Stream<PveClusterStatusState> processEvents(
      PveClusterStatusEvent event) async* {
    if (event is UpdateClusterStatus) {
      final status = await apiClient.getClusterStatus();
      status.sort((a, b) => a.name.compareTo(b.name));
      yield latestState.rebuild((b) => b..model.replace(status));
    }
  }

  @override
  void dispose() {
    updateTimer?.cancel();
    super.dispose();
  }
}

abstract class PveClusterStatusEvent {}

class UpdateClusterStatus extends PveClusterStatusEvent {}
