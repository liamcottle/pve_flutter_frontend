import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:proxmox_dart_api_client/proxmox_dart_api_client.dart';
import 'package:pve_flutter_frontend/bloc/proxmox_base_bloc.dart';

import 'package:pve_flutter_frontend/states/proxmox_form_field_state.dart';


class PveBridgeSelectorBloc
    extends ProxmoxBaseBloc<PveBridgeSelectorEvent, PveBridgeSelectorState> {
  final ProxmoxApiClient apiClient;

  String targetNode;

  InterfaceType bridgeType;

  @override
  PveBridgeSelectorState get initialState =>
      PveBridgeSelectorState(bridges: [], selectedBridge: null, error: null);

  PveBridgeSelectorBloc({
    @required this.apiClient,
    this.targetNode = 'localhost',
    this.bridgeType,
  });

  @override
  Stream<PveBridgeSelectorState> processEvents(
      PveBridgeSelectorEvent event) async* {
    if (event is LoadBridgesEvent) {
      final bridges = await apiClient.getNodeNetwork(targetNode, type: bridgeType);
      yield PveBridgeSelectorState(
          bridges: bridges,
          selectedBridge: bridges?.first,
          error: bridges.isEmpty ? "No bridges available" : null);
    }

    if (event is BridgeSelectedEvent) {
      final bridges = await apiClient.getNodeNetwork(targetNode, type: bridgeType);

      // to make sure it's the same object
      var selection =
          bridges.where((item) => item.iface == event.bridge.iface).single;
      yield PveBridgeSelectorState(bridges: bridges, selectedBridge: selection);
    }

    if (event is ChangeTargetNode) {
      targetNode = event.targetNode;
      final bridges = await apiClient.getNodeNetwork(targetNode, type: bridgeType);
      try {
        var selection = bridges
            .where((item) => item.iface == latestState.value.iface)
            .single;
        yield PveBridgeSelectorState(
          bridges: bridges,
          selectedBridge: selection,
        );
      } on StateError {
        yield PveBridgeSelectorState(
            bridges: bridges,
            selectedBridge: null,
            error: "Please select other bridge");
        return;
      }
    }
  }



  @override
  void dispose() {
    super.dispose();
  }
}

//EVENTS
class PveBridgeSelectorEvent {}

class LoadBridgesEvent extends PveBridgeSelectorEvent {}

class BridgeSelectedEvent extends PveBridgeSelectorEvent {
  final PveNodeNetworkModel bridge;

  BridgeSelectedEvent(this.bridge);
}

class ChangeTargetNode extends PveBridgeSelectorEvent {
  final String targetNode;

  ChangeTargetNode(this.targetNode);
}

//STATES

class PveBridgeSelectorState
    extends PveFormFieldState<PveNodeNetworkModel> {
  final List<PveNodeNetworkModel> bridges;

  PveBridgeSelectorState(
      {this.bridges, PveNodeNetworkModel selectedBridge, String error})
      : super(value: selectedBridge, errorText: error);
}
