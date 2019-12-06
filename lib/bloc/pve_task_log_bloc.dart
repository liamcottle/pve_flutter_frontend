import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pve_flutter_frontend/bloc/proxmox_base_bloc.dart';
import 'package:pve_flutter_frontend/models/pve_cluster_tasks_model.dart';
import 'package:pve_flutter_frontend/models/serializers.dart';
import 'package:proxmox_dart_api_client/proxmox_dart_api_client.dart'
    as proxclient;

class PveTaskLogBloc extends ProxmoxBaseBloc<PVETaskLogEvent, PVETaskLogState>{
  final proxclient.Client apiClient;

  @override
  PVETaskLogState get initialState => null;

  PveTaskLogBloc({@required this.apiClient});

  @override
  Stream<PVETaskLogState> processEvents(PVETaskLogEvent event) async* {
    if (event is LoadRecentTasks) {
      final tasks = await getClusterTasks();
      yield LoadedRecentTasks(tasks);
    }
  }

  Future<List<PveClusterTasksModel>> getClusterTasks() async{
    var response = await apiClient.get(Uri.parse(
          proxclient.getPlatformAwareOrigin() + '/api2/json/cluster/tasks'));
      var data = (json.decode(response.body)['data'] as List).map((f) {
        f["starttime"] = f["starttime"] * 1000 * 1000;
        if (f["endtime"] != null) {
          f["endtime"] = f["endtime"] * 1000 * 1000;
        }
        return serializers.deserializeWith(PveClusterTasksModel.serializer, f);
      }).toList();
      data.sort((a, b) => a.startTime.compareTo(b.startTime));

      return data;
  }
}

abstract class PVETaskLogEvent {}

class LoadRecentTasks extends PVETaskLogEvent{}

abstract class PVETaskLogState {}

class NoTaskLogsAvailable extends PVETaskLogState {}

class LoadedRecentTasks extends PVETaskLogState {
  final List<PveClusterTasksModel> tasks;

  LoadedRecentTasks(this.tasks);
}