import 'dart:async';
import 'dart:convert';

import 'package:pve_flutter_frontend/events/pve_node_selector_events.dart';
import 'package:pve_flutter_frontend/models/pve_nodes_model.dart';
import 'package:pve_flutter_frontend/models/serializers.dart';

import 'package:pve_flutter_frontend/states/pve_node_selector_states.dart';
import 'package:rxdart/rxdart.dart';
import 'package:proxmox_dart_api_client/proxmox_dart_api_client.dart'
    as proxclient;
class PveNodeSelectorBloc {

  final proxclient.Client apiClient;

  final PublishSubject<PveNodeSelectorEvent> _eventSubject =
      PublishSubject<PveNodeSelectorEvent>();

  BehaviorSubject<PveNodeSelectorState> _stateSubject;

  PveNodeSelectorState get initialState => InitalState();
  StreamSink<PveNodeSelectorEvent> get events => _eventSubject.sink;
  Stream<PveNodeSelectorState> get state => _stateSubject.stream;

  PveNodeSelectorBloc({this.apiClient}) {
    _stateSubject = BehaviorSubject<PveNodeSelectorState>.seeded(initialState);

    _eventSubject
        .switchMap((event) => _eventToState(event))
        .forEach((PveNodeSelectorState state) {
      _stateSubject.add(state);
    });
  }

  Stream<PveNodeSelectorState> _eventToState(
      PveNodeSelectorEvent event) async* {
    if (event is LoadNodesEvent) {

      var response = await apiClient
          .get(Uri.parse("https://192.168.24.1:8006/api2/json/nodes"));
      var data = (json.decode(response.body)['data'] as List).map((f) {
        return serializers.deserializeWith(PveNodesModel.serializer, f);
      }).toList();
      yield LoadedNodesState(data.reversed.toList());
    }

    if (event is NodeSelectedEvent) {

      var response = await apiClient
          .get(Uri.parse("https://192.168.24.1:8006/api2/json/nodes"));
      var data = (json.decode(response.body)['data'] as List).map((f) {
        return serializers.deserializeWith(PveNodesModel.serializer, f);
      }).toList();
      // to make sure it's the same object
      var selection = data.where((item) => item.nodeName == event.node.nodeName).single;
      yield LoadedNodesWithSelectionState(nodes: data, selectedNode: selection);
    }
  }

  void dispose() {
    _eventSubject.close();
    _stateSubject.close();
  }
}
