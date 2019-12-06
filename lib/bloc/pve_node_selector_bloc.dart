import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pve_flutter_frontend/bloc/proxmox_base_bloc.dart';
import 'package:pve_flutter_frontend/models/pve_nodes_model.dart';
import 'package:pve_flutter_frontend/models/serializers.dart';
import 'package:pve_flutter_frontend/states/proxmox_form_field_state.dart';

import 'package:proxmox_dart_api_client/proxmox_dart_api_client.dart'
    as proxclient;

class PveNodeSelectorBloc
    extends ProxmoxBaseBloc<PveNodeSelectorEvent, PveNodeSelectorState> {
  final proxclient.Client apiClient;

  final bool onlyOnline;

  @override
  PveNodeSelectorState get initialState => PveNodeSelectorState();

  PveNodeSelectorBloc({this.onlyOnline = true, @required this.apiClient});

  @override
  Stream<PveNodeSelectorState> processEvents(
      PveNodeSelectorEvent event) async* {
    if (event is LoadNodesEvent) {
      final nodes = await getNodes(onlyOnline);
      yield PveNodeSelectorState(
          nodes: nodes,
          selectedNode: nodes?.first,
          error: nodes.isEmpty ? "No nodes available" : null);
    }

    if (event is NodeSelectedEvent) {
      final nodes = await getNodes(onlyOnline);

      // to make sure it's the same object
      var selection =
          nodes.where((item) => item.nodeName == event.node.nodeName).single;
      yield PveNodeSelectorState(nodes: nodes, selectedNode: selection);
    }
  }

  Future<List<PveNodesModel>> getNodes(bool onlyOnline) async {
    var response = await apiClient.get(
        Uri.parse(proxclient.getPlatformAwareOrigin() + '/api2/json/nodes'));
    var data = (json.decode(response.body)['data'] as List).map((f) {
      return serializers.deserializeWith(PveNodesModel.serializer, f);
    });
    if (onlyOnline) data = data.where((node) => node.status == "online");
    var nodes = data.toList();
    nodes.sort((a, b) => a.nodeName.compareTo(b.nodeName));

    return nodes;
  }
}

abstract class PveNodeSelectorEvent {}

class LoadNodesEvent extends PveNodeSelectorEvent {}

class NodeSelectedEvent extends PveNodeSelectorEvent {
  final PveNodesModel node;

  NodeSelectedEvent(this.node);
}

class PveNodeSelectorState extends PveFormFieldState<PveNodesModel> {
  final List<PveNodesModel> nodes;

  PveNodeSelectorState({this.nodes, PveNodesModel selectedNode, String error})
      : super(value: selectedNode, errorText: error);
}
