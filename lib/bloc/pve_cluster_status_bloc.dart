import 'dart:async';
import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:meta/meta.dart';
import 'package:pve_flutter_frontend/bloc/proxmox_base_bloc.dart';
import 'package:pve_flutter_frontend/models/pve_cluster_status_model.dart';
import 'package:pve_flutter_frontend/models/pve_state_cluster_status.dart';
import 'package:proxmox_dart_api_client/proxmox_dart_api_client.dart'
    as proxclient;
import 'package:pve_flutter_frontend/models/serializers.dart';

class PveClusterStatusBloc
    extends ProxmoxBaseBloc<PveClusterStatusEvent, PveClusterStatusState> {
  final proxclient.Client apiClient;
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
      final status = await getClusterStatus();
      yield PveClusterStatusState((b) => b..model.addAll(status));
    }
  }

  Future<List<PveClusterStatusModel>> getClusterStatus() async {
    var url = Uri.parse(
        proxclient.getPlatformAwareOrigin() + '/api2/json/cluster/status');

    var response = await apiClient.get(url);

    var data = (json.decode(response.body)['data'] as List).map((f) {
      return serializers.deserializeWith(PveClusterStatusModel.serializer, f);
    });

    return data.toList();
  }

  @override
  void dispose(){
    updateTimer?.cancel();
    super.dispose();
  }
}

abstract class PveClusterStatusEvent {}

class UpdateClusterStatus extends PveClusterStatusEvent {}
