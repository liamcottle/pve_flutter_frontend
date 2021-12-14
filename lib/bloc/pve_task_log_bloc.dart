import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pve_flutter_frontend/bloc/proxmox_base_bloc.dart';
import 'package:proxmox_dart_api_client/proxmox_dart_api_client.dart';
import 'package:pve_flutter_frontend/states/pve_task_log_state.dart';

class PveTaskLogBloc extends ProxmoxBaseBloc<PVETaskLogEvent, PveTaskLogState> {
  final ProxmoxApiClient apiClient;
  final PveTaskLogState init;

  @override
  PveTaskLogState get initialState => init;

  PveTaskLogBloc({required this.apiClient, required this.init});

  Timer? updateTasks;

  @override
  void doOnListen() {
    updateTasks = Timer.periodic(Duration(seconds: 4), (timer) {
      events.add(UpdateTasks());
    });
  }

  @override
  void doOnCancel() {
    if (!hasListener) {
      updateTasks?.cancel();
    }
  }

  @override
  Stream<PveTaskLogState> processEvents(PVETaskLogEvent event) async* {
    //Reset after first event added to pipe
    yield latestState.rebuild((b) => b..isBlank = false);

    if (event is LoadTasks) {
      var nodeTaskResponse;
      yield latestState.rebuild((b) => b..isLoading = true);

      nodeTaskResponse = await getNodeTasks(latestState);

      yield latestState.rebuild((b) => b
        ..tasks.replace(nodeTaskResponse.tasks)
        ..total = nodeTaskResponse.total
        ..isLoading = false);
    }

    if (event is UpdateTasks) {
      if (latestState.limit >= latestState.tasks.length &&
          !latestState.isLoading) {
        final taskResponse = await getNodeTasks(latestState);
        yield latestState.rebuild((b) => b..tasks.replace(taskResponse.tasks!));
      }
    }

    if (event is LoadMoreTasks) {
      if ((latestState.total > latestState.tasks.length) &&
          !latestState.isLoading) {
        yield latestState.rebuild((b) => b..isLoading = true);
        final nodeTaskResponse =
            await getNodeTasks(latestState, start: latestState.tasks.length);

        yield latestState.rebuild((b) => b
          ..tasks
              .addAll(nodeTaskResponse.tasks as Iterable<PveClusterTasksModel>)
          ..total = nodeTaskResponse.total
          ..isLoading = false);
      }
    }

    if (event is FilterTasksByGuestID) {
      yield latestState.rebuild((b) => b..guestID = event.guestID);
    }

    if (event is FilterTasksByError) {
      yield latestState.rebuild((b) => b..onlyErrors = !b.onlyErrors!);
    }

    if (event is FilterTasksByUser) {
      yield latestState.rebuild((b) => b..userFilter = event.user);
    }

    if (event is FilterTasksByType) {
      yield latestState.rebuild((b) => b..typeFilter = event.type);
    }

    if (event is FilterTasksBySource) {
      yield latestState.rebuild((b) => b..source = event.source);
    }
  }

  Future<NodeTasksResponse> getNodeTasks(PveTaskLogState state,
      {int? start, int limit = 50}) async {
    return await apiClient.getNodeTasks(
      state.nodeID,
      limit: limit.toString(),
      guestId: state.guestID,
      source: state.source,
      userfilter: state.userFilter,
      typefilter: state.typeFilter,
      errors: state.onlyErrors,
      start: start?.toString(),
    );
  }
}

abstract class PVETaskLogEvent {}

class LoadTasks extends PVETaskLogEvent {}

class LoadMoreTasks extends PVETaskLogEvent {
  final int limit;

  LoadMoreTasks({
    this.limit = 50,
  });
}

class UpdateTasks extends PVETaskLogEvent {}

class FilterTasksByGuestID extends PVETaskLogEvent {
  final String guestID;

  FilterTasksByGuestID({
    required this.guestID,
  });
}

class FilterTasksByError extends PVETaskLogEvent {}

class FilterTasksByUser extends PVETaskLogEvent {
  final String user;

  FilterTasksByUser(this.user);
}

class FilterTasksByType extends PVETaskLogEvent {
  final String type;

  FilterTasksByType(this.type);
}

class FilterTasksBySource extends PVETaskLogEvent {
  final String? source;

  FilterTasksBySource(this.source);
}
