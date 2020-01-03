import 'dart:async';
import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:pve_flutter_frontend/bloc/proxmox_base_bloc.dart';
import 'package:pve_flutter_frontend/states/pve_state_cluster_status.dart';
import 'package:proxmox_dart_api_client/proxmox_dart_api_client.dart';

class PveClusterStatusBloc
    extends ProxmoxBaseBloc<PveClusterStatusEvent, PveClusterStatusState> {
  final ProxmoxApiClient apiClient;
  PveClusterStatusState get initialState => null;
  Timer updateTimer;

  @override
  void doOnListen() {
    updateTimer = Timer.periodic(Duration(seconds: 5), (timer) => events.add(UpdateClusterStatus()));
  }

  @override
  void doOnCancel() {
    if (!hasListener) {
      updateTimer?.cancel();
    }
  }

  PveClusterStatusBloc({@required this.apiClient});

  Stream<PveClusterStatusState> processEvents(
      PveClusterStatusEvent event) async* {
    if (event is UpdateClusterStatus) {
      final status = await apiClient.getClusterStatus();
      yield PveClusterStatusState((b) => b..model.addAll(status));
    }
  }



  @override
  void dispose(){
    updateTimer?.cancel();
    super.dispose();
  }
}

abstract class PveClusterStatusEvent {}

class UpdateClusterStatus extends PveClusterStatusEvent {}
