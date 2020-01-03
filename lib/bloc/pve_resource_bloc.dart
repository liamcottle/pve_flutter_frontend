import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:pve_flutter_frontend/bloc/proxmox_base_bloc.dart';
import 'package:proxmox_dart_api_client/proxmox_dart_api_client.dart';

class PveResourceBloc
    extends ProxmoxBaseBloc<PveResourceEvents, PveResourceState> {
  final ProxmoxApiClient apiClient;

  PveResourceBloc({@required this.apiClient});

  @override
  get initialState => PveResourceState(resources: []);

  Timer updateTimer;

  @override
  void doOnListen() {
    updateTimer = Timer.periodic(
        Duration(seconds: 5), (timer) => events.add(PollResources()));
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
      final resources = await apiClient.getResources();
      resources.sort((a, b) => a.id.compareTo(b.id));
      yield PveResourceState(resources: resources);
    }

    if (event is PerformActionOnResource) {
      await startResource(event.action, event.resource);
      yield latestState;
    }
  }

  Future<void> startResource(
      ResourceAction action, PveClusterResourcesModel resource) async {
    Uri url;
    if (resource.type == "qemu" || resource.type == "lxc") {
      url = Uri.parse(await getPlatformAwareOrigin() +
          '/api2/json/nodes/${resource.node}/${resource.type}/${resource.vmid}/status/' +
          describeEnum(action));
    }

    if (resource.type == "node") {
      url = Uri.parse(await getPlatformAwareOrigin() +
          '/api2/json/nodes/${resource.node}/status/?command=' +
          describeEnum(action));
    }
    var response = await apiClient.post(url);
  }
}

class PveResourceState {
  final List<PveClusterResourcesModel> resources;

  PveResourceState({this.resources});
}

abstract class PveResourceEvents {}

class PollResources extends PveResourceEvents {}

enum ResourceAction { start, stop, shutdown, resume, reboot }

class PerformActionOnResource extends PveResourceEvents {
  final ResourceAction action;
  final PveClusterResourcesModel resource;
  PerformActionOnResource(this.action, this.resource);
}
