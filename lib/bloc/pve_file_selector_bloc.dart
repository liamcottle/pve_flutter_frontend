import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:pve_flutter_frontend/bloc/proxmox_base_bloc.dart';
import 'package:proxmox_dart_api_client/proxmox_dart_api_client.dart';

class PveFileSelectorBloc
    extends ProxmoxBaseBloc<PveFileSelectorEvent, PveFileSelectorState> {
  final ProxmoxApiClient apiClient;

  String nodeId;

  String storageId;

  PveStorageContentType fileType;

  @override
  PveFileSelectorState get initialState => PveFileSelectorState();

  PveFileSelectorBloc(
      {@required this.apiClient,
      this.nodeId = 'localhost',
      this.storageId,
      this.fileType});

  @override
  Stream<PveFileSelectorState> processEvents(event) async* {
    if (event is LoadStorageContent) {
      final content = await loadStorageContent(fileType);
      yield state.value.copyWith(content: content);
    }

    if (event is ChangeStorage) {
      storageId = event.storageId;
      final content = await loadStorageContent(fileType);
      yield state.value.copyWith(content: content, search: false);
    }

    if (event is ToggleGridListView) {
      yield state.value.copyWith(gridView: !state.value.gridView);
    }

    if (event is ToggleSearch) {
      final content = await loadStorageContent(fileType);
      yield state.value.copyWith(content: content, search: !state.value.search);
    }

    if (event is FilterContent) {
      final content = await loadStorageContent(fileType, event.searchTerm);
      yield state.value.copyWith(content: content);
    }
  }

  Future<List<PveNodesStorageContentModel>> loadStorageContent(
      PveStorageContentType type,
      [String filterVolid]) async {
    final data = await apiClient.getNodeStorageContent(nodeId, storageId, content: type);

    if (filterVolid != null && filterVolid.isNotEmpty) {
      return data.where((item) => item.volid.contains(filterVolid)).toList();
    } else {
      return data.toList();
    }
  }
}

abstract class PveFileSelectorEvent {}

class LoadStorageContent extends PveFileSelectorEvent {
  final PveStorageContentType type;

  LoadStorageContent({this.type});
}

class ToggleGridListView extends PveFileSelectorEvent {}

class ChangeNode extends PveFileSelectorEvent {}

class ChangeStorage extends PveFileSelectorEvent {
  final String storageId;

  ChangeStorage(this.storageId);
}

class ToggleSearch extends PveFileSelectorEvent {}

class FilterContent extends PveFileSelectorEvent {
  final String searchTerm;

  FilterContent({this.searchTerm});
}

class PveFileSelectorState {
  final List<PveNodesStorageContentModel> content;
  final bool gridView;
  final bool search;

  PveFileSelectorState({
    this.content,
    this.gridView = false,
    this.search = false,
  });

  PveFileSelectorState copyWith({
    List<PveNodesStorageContentModel> content,
    bool gridView,
    bool search,
  }) {
    return PveFileSelectorState(
        content: content ?? this.content,
        gridView: gridView ?? this.gridView,
        search: search ?? this.search);
  }
}
