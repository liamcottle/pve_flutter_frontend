import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pve_flutter_frontend/bloc/proxmox_base_bloc.dart';
import 'package:pve_flutter_frontend/models/pve_nodes_storage_model.dart';
import 'package:pve_flutter_frontend/models/serializers.dart';
import 'package:pve_flutter_frontend/states/proxmox_form_field_state.dart';
import 'package:pve_flutter_frontend/models/pve_nodes_storage_content_model.dart';
import 'package:proxmox_dart_api_client/proxmox_dart_api_client.dart'
    as proxclient;

class PveStorageSelectorBloc
    extends ProxmoxBaseBloc<PveStorageSelectorEvent, PveStorageSelectorState> {
  final proxclient.Client apiClient;

  bool fetchEnabledStoragesOnly;

  PveStorageContentType content;

  String targetNode;

  @override
  PveStorageSelectorState get initialState => PveStorageSelectorState();

  PveStorageSelectorBloc(
      {this.fetchEnabledStoragesOnly = true,
      @required this.apiClient,
      this.targetNode = 'localhost',
      this.content});

  @override
  Stream<PveStorageSelectorState> processEvents(
      PveStorageSelectorEvent event) async* {
    if (event is LoadStoragesEvent) {
      final storages = await getStorages(fetchEnabledStoragesOnly, targetNode);
      yield PveStorageSelectorState(
          storages: storages,
          selectedStorage: storages?.first,
          error: storages.isEmpty ? "No storage available" : null);
    }

    if (event is StorageSelectedEvent) {
      final storages = await getStorages(fetchEnabledStoragesOnly, targetNode);

      // to make sure it's the same object
      var selection =
          storages.where((item) => item.id == event.storage.id).single;
      yield PveStorageSelectorState(
          storages: storages, selectedStorage: selection);
    }

    if (event is ChangeTargetNode) {
      targetNode = event.targetNode;
      final storages = await getStorages(fetchEnabledStoragesOnly, targetNode);
      try {
        var selection =
            storages.where((item) => item.id == state.value.value.id).single;
        yield PveStorageSelectorState(
          storages: storages,
          selectedStorage: selection,
        );
      } on StateError {
        yield PveStorageSelectorState(
            storages: storages,
            selectedStorage: null,
            error: "Please select other Storage");
        return;
      }
    }
  }

  Future<List<PveNodesStorageModel>> getStorages(
      bool fetchEnabledStoragesOnly, String targetNode) async {

    var url = Uri.parse(proxclient.getPlatformAwareOrigin() +
        '/api2/json/nodes/$targetNode/storage');
    Map<String, dynamic> queryParameters = {};

    if (fetchEnabledStoragesOnly) {
      queryParameters['enabled'] = '1';
    }

    if (content != null) {
      queryParameters['content'] = describeEnum(content);
    }

    url = url.replace(queryParameters: queryParameters);

    var response = await apiClient.get(url);

    var data = (json.decode(response.body)['data'] as List).map((f) {
      return serializers.deserializeWith(PveNodesStorageModel.serializer, f);
    });

    var storages = data.toList();
    storages.sort((a, b) => a.id.compareTo(b.id));

    return storages;
  }

  @override
  void dispose() {
    super.dispose();
  }
}

//EVENTS
class PveStorageSelectorEvent {}

class LoadStoragesEvent extends PveStorageSelectorEvent {}

class StorageSelectedEvent extends PveStorageSelectorEvent {
  final PveNodesStorageModel storage;

  StorageSelectedEvent(this.storage);
}

class ChangeTargetNode extends PveStorageSelectorEvent {
  final String targetNode;

  ChangeTargetNode(this.targetNode);
}

//STATES

class PveStorageSelectorState extends PveFormFieldState<PveNodesStorageModel> {
  final List<PveNodesStorageModel> storages;

  PveStorageSelectorState(
      {this.storages, PveNodesStorageModel selectedStorage, String error})
      : super(value: selectedStorage, errorText: error);
}