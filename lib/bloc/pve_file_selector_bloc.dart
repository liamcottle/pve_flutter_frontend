import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:pve_flutter_frontend/bloc/proxmox_base_bloc.dart';
import 'package:proxmox_dart_api_client/proxmox_dart_api_client.dart';
import 'package:pve_flutter_frontend/states/pve_file_selector_state.dart';

class PveFileSelectorBloc
    extends ProxmoxBaseBloc<PveFileSelectorEvent, PveFileSelectorState> {
  final ProxmoxApiClient apiClient;
  final PveFileSelectorState init;
  @override
  PveFileSelectorState get initialState => init;

  PveFileSelectorBloc({@required this.apiClient, @required this.init});

  @override
  Stream<PveFileSelectorState> processEvents(event) async* {
    if (event is LoadStorageContent) {
      if (latestState.nodeID != null && latestState.storageID != null) {
        final content = await loadStorageContent(latestState);
        yield latestState.rebuild((b) => b..content.replace(content));
      }
    }

    if (event is ChangeStorage) {
      yield latestState.rebuild((b) => b..storageID = event.storageId);
      events.add(LoadStorageContent());
    }

    if (event is ToggleGridListView) {
      yield latestState.rebuild((b) => b..gridView = !b.gridView);
    }

    if (event is ToggleSearch) {
      yield latestState.rebuild((b) => b..search = !b.search);
    }

    if (event is FilterContent) {
      yield latestState.rebuild((b) => b..volidFilter = event.searchTerm);
      events.add(LoadStorageContent());
    }

    if (event is DeleteFile) {
      try {
        await apiClient.deleteNodeStorageContent(
            latestState.nodeID, latestState.storageID, event.volume,
            delay: 5);
      } on ProxmoxApiException catch (e) {
        print(e);
      }
      events.add(LoadStorageContent());
    }
  }

  Future<List<PveNodesStorageContentModel>> loadStorageContent(
      PveFileSelectorState state) async {
    final data = await apiClient.getNodeStorageContent(
        state.nodeID, state.storageID,
        content: state.fileType);

    if (state.volidFilter != null && state.volidFilter.isNotEmpty) {
      return data
          .where((item) => item.volid.contains(state.volidFilter))
          .toList();
    } else {
      return data.toList();
    }
  }
}

abstract class PveFileSelectorEvent {}

class LoadStorageContent extends PveFileSelectorEvent {
  LoadStorageContent();
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

class DeleteFile extends PveFileSelectorEvent {
  final String volume;

  DeleteFile(this.volume);
}
