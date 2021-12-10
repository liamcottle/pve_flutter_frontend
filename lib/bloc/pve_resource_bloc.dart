import 'dart:async';

import 'package:built_collection/built_collection.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:pve_flutter_frontend/bloc/proxmox_base_bloc.dart';
import 'package:proxmox_dart_api_client/proxmox_dart_api_client.dart';
import 'package:pve_flutter_frontend/states/pve_resource_state.dart';

/// PveResourceBloc will per default fetch all cluster resources (periodically),
/// if no ProxmoxApiClient is provided it won't do anything until one is added
/// and a view subscribes to it.
class PveResourceBloc
    extends ProxmoxBaseBloc<PveResourceEvents, PveResourceState> {
  ProxmoxApiClient? apiClient;

  PveResourceBloc({this.apiClient, required this.init});

  PveResourceState init;

  bool get isFiltered =>
      latestState.typeFilter != init.typeFilter ||
      latestState.subFilter != init.subFilter ||
      latestState.nodeFilter != init.nodeFilter ||
      latestState.poolFilter != init.poolFilter ||
      latestState.statusFilter != init.statusFilter ||
      latestState.nameFilter != init.nameFilter;

  @override
  PveResourceState get initialState => init;

  Timer? updateTimer;

  @override
  void doOnListen() {
    if (apiClient != null) {
      updateTimer = Timer.periodic(Duration(seconds: 3),
          (timer) => apiClient != null ? events.add(PollResources()) : null);
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
      var resources = await apiClient?.getResources();
      if (resources != null) {
        resources.sort((a, b) => a.id.compareTo(b.id));
        yield latestState.rebuild((b) => b..resources.replace(resources));
      }
    }

    if (event is PerformActionOnResource) {
      final resource = event.resource;
      await apiClient?.doResourceAction(
          resource.node!, resource.id, resource.type, event.action);
    }

    if (event is FilterResources) {
      yield latestState.rebuild((b) => b
        ..typeFilter.replace(event.typeFilter ?? latestState.typeFilter)
        ..subFilter.replace(event.subscriptionfilter ?? latestState.subFilter)
        ..nodeFilter.replace(event.nodeFilter ?? latestState.nodeFilter)
        ..poolFilter.replace(event.poolFilter ?? latestState.poolFilter)
        ..statusFilter.replace(event.statusFilter ?? latestState.statusFilter)
        ..nameFilter = event.nameFilter ?? latestState.nameFilter);
    }

    if (event is ResetFilter) {
      yield latestState.rebuild((b) => b
        ..typeFilter.replace(init.typeFilter)
        ..subFilter.replace(init.subFilter)
        ..nodeFilter.replace(init.nodeFilter)
        ..poolFilter.replace(init.poolFilter)
        ..statusFilter.replace(init.statusFilter)
        ..nameFilter = init.nameFilter);
    }
  }
}

abstract class PveResourceEvents {}

class PollResources extends PveResourceEvents {}

class FilterResources extends PveResourceEvents {
  final BuiltSet<String>? typeFilter;
  final BuiltSet<String>? subscriptionfilter;
  final BuiltSet<String>? nodeFilter;
  final BuiltSet<String>? poolFilter;
  final BuiltSet<PveResourceStatusType>? statusFilter;
  final String? nameFilter;

  FilterResources({
    this.typeFilter,
    this.subscriptionfilter,
    this.nodeFilter,
    this.poolFilter,
    this.statusFilter,
    this.nameFilter,
  });
}

class ResetFilter extends PveResourceEvents {}

class PerformActionOnResource extends PveResourceEvents {
  final PveClusterResourceAction action;
  final PveClusterResourcesModel resource;
  PerformActionOnResource(this.action, this.resource);
}
