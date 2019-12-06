import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:pve_flutter_frontend/bloc/proxmox_base_bloc.dart';
import 'package:pve_flutter_frontend/models/pve_cluster_resources_model.dart';
import 'package:proxmox_dart_api_client/proxmox_dart_api_client.dart'
    as proxclient;
import 'package:pve_flutter_frontend/models/serializers.dart';

class PveResourceBloc
    extends ProxmoxBaseBloc<PveResourceEvents, PveResourceState> {
  final proxclient.Client apiClient;

  PveResourceBloc({@required this.apiClient});

  @override
  get initialState => PveResourceState(resources: []);

  @override
  Stream<PveResourceState> processEvents(event) async* {
    if (event is PollResources) {
      final resources = await getResources();
      yield PveResourceState(resources: resources);
    }

    if (event is PerformActionOnResource) {
      await startResource(event.action, event.resource);
      yield latestState;
    }
  }

  Future<List<PveClusterResourcesModel>> getResources() async {
    var url = Uri.parse(
        proxclient.getPlatformAwareOrigin() + '/api2/json/cluster/resources');
    Map<String, dynamic> queryParameters = {};

    url = url.replace(queryParameters: queryParameters);

    var response = await apiClient.get(url);

    var data = (json.decode(response.body)['data'] as List).map((f) {
      return serializers.deserializeWith(
          PveClusterResourcesModel.serializer, f);
    });

    var resources = data.toList();
    resources.sort((a, b) => a.type.compareTo(b.type));

    return resources;
  }

  Future<void> startResource(
      ResourceAction action, PveClusterResourcesModel resource) async {
    Uri url;
    if(resource.type == "qemu" || resource.type == "lxc"){
        url = Uri.parse(proxclient.getPlatformAwareOrigin() +
            '/api2/json/nodes/${resource.node}/${resource.type}/${resource.vmid}/status/' +
            describeEnum(action));
    }

    if (resource.type == "node") {
      url = Uri.parse(proxclient.getPlatformAwareOrigin() +
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
