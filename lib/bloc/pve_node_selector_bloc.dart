import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pve_flutter_frontend/bloc/proxmox_base_bloc.dart';
import 'package:proxmox_dart_api_client/proxmox_dart_api_client.dart';
import 'package:pve_flutter_frontend/states/pve_node_selector_state.dart';

class PveNodeSelectorBloc
    extends ProxmoxBaseBloc<PveNodeSelectorEvent, PveNodeSelectorState> {
  final ProxmoxApiClient apiClient;
  final PveNodeSelectorState init;
  @override
  PveNodeSelectorState get initialState => init;

  PveNodeSelectorBloc({@required this.apiClient, @required this.init});

  @override
  Stream<PveNodeSelectorState> processEvents(
      PveNodeSelectorEvent event) async* {
    if (event is LoadNodesEvent) {
      final nodes = await apiClient.getNodes();

      nodes.sort((a, b) => a.nodeName.compareTo(b.nodeName));
      yield latestState.rebuild((b) => b..nodes.replace(nodes));
    }

    if (event is NodeSelectedEvent) {
      final sl = latestState.nodes
          .firstWhere((element) => element.nodeName == event.nodeName);
      yield latestState.rebuild((b) => b..selectedNode.replace(sl));
    }

    if (event is ExcludeOfflineNodes) {
      yield latestState.rebuild((b) => b..onlineValidator = !b.onlineValidator);
    }

    if (event is UpdateAllowedNodes) {
      yield latestState.rebuild((b) => b..allowedNodes.replace(event.nodes));
    }

    if (event is UpdateDisallowedNodes) {
      yield latestState.rebuild((b) => b..disallowedNodes.replace(event.nodes));
    }

    if (event is ResetNodeSelector) {
      yield init;
      events.add(LoadNodesEvent());
    }
  }

  Future<List<PveNodesModel>> getNodes(bool onlyOnline) async {
    var nodes = await apiClient.getNodes();
    if (onlyOnline)
      nodes = nodes.where((node) => node.status == "online").toList();
    nodes.sort((a, b) => a.nodeName.compareTo(b.nodeName));
    return nodes;
  }
}

abstract class PveNodeSelectorEvent {}

class LoadNodesEvent extends PveNodeSelectorEvent {}

class NodeSelectedEvent extends PveNodeSelectorEvent {
  final String nodeName;

  NodeSelectedEvent(this.nodeName);
}

class ExcludeOfflineNodes extends PveNodeSelectorEvent {}

class UpdateAllowedNodes extends PveNodeSelectorEvent {
  final Set<String> nodes;

  UpdateAllowedNodes(this.nodes);
}

class UpdateDisallowedNodes extends PveNodeSelectorEvent {
  final Set<String> nodes;

  UpdateDisallowedNodes(this.nodes);
}

class ResetNodeSelector extends PveNodeSelectorEvent {}
