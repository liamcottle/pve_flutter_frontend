import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pve_flutter_frontend/bloc/proxmox_base_bloc.dart';
import 'package:proxmox_dart_api_client/proxmox_dart_api_client.dart';

class PveTaskLogBloc extends ProxmoxBaseBloc<PVETaskLogEvent, PVETaskLogState>{
  final ProxmoxApiClient apiClient;

  @override
  PVETaskLogState get initialState => null;

  PveTaskLogBloc({@required this.apiClient});

  @override
  Stream<PVETaskLogState> processEvents(PVETaskLogEvent event) async* {
    if (event is LoadRecentTasks) {
      final tasks = await apiClient.getClusterTasks();
      tasks.sort((a, b) => a.startTime.compareTo(b.startTime));
      yield LoadedRecentTasks(tasks);
    }
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