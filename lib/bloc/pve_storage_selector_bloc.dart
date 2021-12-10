import 'dart:async';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pve_flutter_frontend/bloc/proxmox_base_bloc.dart';
import 'package:proxmox_dart_api_client/proxmox_dart_api_client.dart';
import 'package:pve_flutter_frontend/states/pve_storage_selector_state.dart';

class PveStorageSelectorBloc
    extends ProxmoxBaseBloc<PveStorageSelectorEvent, PveStorageSelectorState> {
  final ProxmoxApiClient apiClient;
  final PveStorageSelectorState init;
  @override
  PveStorageSelectorState get initialState => init;

  PveStorageSelectorBloc({
    required this.apiClient,
    required this.init,
  });

  @override
  Stream<PveStorageSelectorState> processEvents(
      PveStorageSelectorEvent event) async* {
    if (event is LoadStoragesEvent) {
      yield latestState.rebuild((b) => b..isLoading = true);
      final storages = await getStorages(latestState);

      var selected = storages.singleWhereOrNull(
          (element) => element.id == latestState.selected?.id);

      if (selected == null && latestState.selected != null) {
        yield* yieldErrorState('Selected storage no longer available');
      }

      if (storages.length == 1 && selected == null) {
        selected = storages.single;
      }
      if (selected != null) {
        yield latestState.rebuild((b) => b
          ..isBlank = false
          ..isLoading = false
          ..storages.replace(storages)
          ..selected.replace(selected!));
      } else {
        yield latestState.rebuild((b) => b
          ..isBlank = false
          ..isLoading = false
          ..storages.replace(storages)
          ..selected = null);
      }
    }

    if (event is StorageSelectedEvent) {
      if (event.storageID == null) {
        yield latestState.rebuild((b) => b..selected.replace(event.storage!));
      } else {
        final storage =
            latestState.storages.singleWhere((s) => s.id == event.storageID);
        yield latestState.rebuild((b) => b..selected.replace(storage));
      }
    }

    if (event is NodeChanged) {
      yield latestState.rebuild((b) => b..nodeID = event.nodeID);
      events.add(LoadStoragesEvent());
    }
  }

  Future<List<PveNodesStorageModel>> getStorages(
      PveStorageSelectorState state) async {
    var storages = await apiClient.getNodeStorage(state.nodeID,
        content: state.content,
        enabled: state.enabledOnly,
        storageId: state.storage);
    storages.sort((a, b) => a.id.compareTo(b.id));
    if (state.filterActive) {
      storages = storages.where((element) => element.active == true).toList();
    }
    return storages;
  }

  Stream<PveStorageSelectorState> yieldErrorState(String errorText) async* {
    yield latestState.rebuild((b) => b..errorMessage = errorText);
    yield latestState.rebuild((b) => b..errorMessage = "");
  }
}

//EVENTS
class PveStorageSelectorEvent {}

class LoadStoragesEvent extends PveStorageSelectorEvent {}

class StorageSelectedEvent extends PveStorageSelectorEvent {
  final PveNodesStorageModel? storage;
  final String? storageID;
  StorageSelectedEvent({this.storage, this.storageID});
}

class NodeChanged extends PveStorageSelectorEvent {
  final String nodeID;

  NodeChanged(this.nodeID);
}
