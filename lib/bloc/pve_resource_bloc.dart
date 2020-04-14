import 'dart:async';

import 'package:built_collection/built_collection.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:pve_flutter_frontend/bloc/proxmox_base_bloc.dart';
import 'package:proxmox_dart_api_client/proxmox_dart_api_client.dart';
import 'package:pve_flutter_frontend/states/pve_resource_state.dart';

class PveResourceBloc
    extends ProxmoxBaseBloc<PveResourceEvents, PveResourceState> {
  ProxmoxApiClient apiClient;

  PveResourceBloc({@required this.apiClient, @required this.init});

  PveResourceState init;

  @override
  PveResourceState get initialState => init;

  Timer updateTimer;

  @override
  void doOnListen() {
    if (apiClient != null) {
      updateTimer = Timer.periodic(
          Duration(seconds: 6), (timer) => events.add(PollResources()));
    }
  }

  @override
  void doOnCancel() {
    if (!hasListener) {
      updateTimer?.cancel();
    }
  }

  @override
  Stream<PveResourceState> processEvents(event) async* {
    if (event is PollResources) {
      var resources = await apiClient.getResources();
      resources.sort((a, b) => a.id.compareTo(b.id));
      yield latestState.rebuild((b) => b..resources.replace(resources));
    }

    if (event is PerformActionOnResource) {
      final resource = event.resource;
      await apiClient.doResourceAction(
          resource.node, resource.id, resource.type, event.action);
    }

    if (event is FilterByType) {
      yield latestState.rebuild((b) => b..typeFilter.replace(event.filter));
    }

    if (event is FilterBySubscription) {
      yield latestState.rebuild((b) => b..subFilter.replace(event.filter));
    }

    if (event is FilterByNode) {
      yield latestState.rebuild((b) => b..nodeFilter.replace(event.filter));
    }

    if (event is FilterByPool) {
      yield latestState.rebuild((b) => b..poolFilter.replace(event.filter));
    }

    if (event is FilterByStatus) {
      yield latestState.rebuild((b) => b..statusFilter = !b.statusFilter);
    }

    if (event is FilterByName) {
      yield latestState.rebuild((b) => b..nameFilter = event.filter);
    }
  }
}

abstract class PveResourceEvents {}

class PollResources extends PveResourceEvents {}

class FilterByType extends PveResourceEvents {
  final BuiltSet<String> filter;

  FilterByType(this.filter);
}

class FilterBySubscription extends PveResourceEvents {
  final BuiltSet<String> filter;

  FilterBySubscription(this.filter);
}

class FilterByNode extends PveResourceEvents {
  final BuiltSet<String> filter;

  FilterByNode(this.filter);
}

class FilterByPool extends PveResourceEvents {
  final BuiltSet<String> filter;

  FilterByPool(this.filter);
}

class FilterByStatus extends PveResourceEvents {}

class FilterByName extends PveResourceEvents {
  final String filter;

  FilterByName(this.filter);
}

class PerformActionOnResource extends PveResourceEvents {
  final PveClusterResourceAction action;
  final PveClusterResourcesModel resource;
  PerformActionOnResource(this.action, this.resource);
}
