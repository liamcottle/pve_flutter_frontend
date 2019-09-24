import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pve_flutter_frontend/events/pve_task_log_events.dart';
import 'package:pve_flutter_frontend/models/pve_cluster_tasks_model.dart';
import 'package:pve_flutter_frontend/models/serializers.dart';
import 'package:pve_flutter_frontend/states/pve_task_log_states.dart';
import 'package:proxmox_dart_api_client/proxmox_dart_api_client.dart'
    as proxclient;
import 'package:rxdart/rxdart.dart';

class PveTaskLogBloc {

  final proxclient.Client apiClient;

  final PublishSubject<PVETaskLogEvent> _eventSubject =
      PublishSubject<PVETaskLogEvent>();

  BehaviorSubject<PVETaskLogState> _stateSubject;

  PVETaskLogState get initialState => NoTaskLogsAvailable();
  StreamSink<PVETaskLogEvent> get events => _eventSubject.sink;
  Stream<PVETaskLogState> get state => _stateSubject.stream;

  PveTaskLogBloc({@required this.apiClient}) {
    _stateSubject = BehaviorSubject<PVETaskLogState>.seeded(initialState);

    _eventSubject
        .switchMap((event) => _eventToState(event))
        .forEach((PVETaskLogState state) {
      _stateSubject.add(state);
    });
  }

  Stream<PVETaskLogState> _eventToState(PVETaskLogEvent event) async* {
    if (event is LoadRecentTasks) {

      var response = await apiClient
          .get(Uri.parse(proxclient.getPlatformAwareOrigin() + '/api2/json/cluster/tasks'));
      var data = (json.decode(response.body)['data'] as List).map((f) {
        f["starttime"] = f["starttime"] * 1000 * 1000;
        if (f["endtime"] != null) {
          f["endtime"] = f["endtime"] * 1000 * 1000;
        }
        return serializers.deserializeWith(PveClusterTasksModel.serializer, f);
      }).toList();
      data.sort((a, b) => a.startTime.compareTo(b.startTime));
      yield LoadedRecentTasks(data.reversed.toList());
    }
  }

  void dispose() {
    _eventSubject.close();
    _stateSubject.close();
  }
}
