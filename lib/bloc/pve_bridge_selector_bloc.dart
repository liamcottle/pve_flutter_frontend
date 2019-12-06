import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pve_flutter_frontend/bloc/proxmox_base_bloc.dart';
import 'package:pve_flutter_frontend/models/pve_nodes_network_model.dart';
import 'package:pve_flutter_frontend/models/serializers.dart';
import 'package:pve_flutter_frontend/states/proxmox_form_field_state.dart';
import 'package:proxmox_dart_api_client/proxmox_dart_api_client.dart'
    as proxclient;

class PveBridgeSelectorBloc
    extends ProxmoxBaseBloc<PveBridgeSelectorEvent, PveBridgeSelectorState> {
  final proxclient.Client apiClient;

  String targetNode;

  BridgeType bridgeType;

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
      final bridges = await getBridges(bridgeType, targetNode);
      yield PveBridgeSelectorState(
          bridges: bridges,
          selectedBridge: bridges?.first,
          error: bridges.isEmpty ? "No bridges available" : null);
    }

    if (event is BridgeSelectedEvent) {
      final bridges = await getBridges(bridgeType, targetNode);

      // to make sure it's the same object
      var selection =
          bridges.where((item) => item.iface == event.bridge.iface).single;
      yield PveBridgeSelectorState(bridges: bridges, selectedBridge: selection);
    }

    if (event is ChangeTargetNode) {
      targetNode = event.targetNode;
      final bridges = await getBridges(bridgeType, targetNode);
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

  Future<List<PveNodeNetworkReadModel>> getBridges(
      BridgeType type, String targetNode) async {
    var url = Uri.parse(proxclient.getPlatformAwareOrigin() +
        '/api2/json/nodes/$targetNode/network');
    Map<String, dynamic> queryParameters = {};

    queryParameters['type'] = type?.name ?? 'any_bridge';

    url = url.replace(queryParameters: queryParameters);

    var response = await apiClient.get(url);

    var data = (json.decode(response.body)['data'] as List).map((f) {
      return serializers.deserializeWith(PveNodeNetworkReadModel.serializer, f);
    });

    var bridges = data.toList();
    bridges.sort((a, b) => a.iface.compareTo(b.iface));

    return bridges;
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
  final PveNodeNetworkReadModel bridge;

  BridgeSelectedEvent(this.bridge);
}

class ChangeTargetNode extends PveBridgeSelectorEvent {
  final String targetNode;

  ChangeTargetNode(this.targetNode);
}

//STATES

class PveBridgeSelectorState
    extends PveFormFieldState<PveNodeNetworkReadModel> {
  final List<PveNodeNetworkReadModel> bridges;

  PveBridgeSelectorState(
      {this.bridges, PveNodeNetworkReadModel selectedBridge, String error})
      : super(value: selectedBridge, errorText: error);
}
