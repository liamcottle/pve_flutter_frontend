library pve_node_overview_state;

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/serializer.dart';
import 'package:proxmox_dart_api_client/proxmox_dart_api_client.dart';
import 'package:pve_flutter_frontend/states/pve_base_state.dart';

part 'pve_node_overview_state.g.dart';

abstract class PveNodeOverviewState
    with PveBaseState
    implements Built<PveNodeOverviewState, PveNodeOverviewStateBuilder> {
  // Fields
  @nullable
  PveNodeStatusModel get status;

  BuiltList<PveNodeRRDDataModel> get rrdData;
  BuiltList<PveNodeServicesModel> get services;
  BuiltList<PveNodesAptUpdateModel> get updates;
  BuiltList<PveNodesDisksListModel> get disks;
  bool get standalone;

  bool get allServicesRunning => !services.any((s) {
        if (s.name == 'corosync' && standalone) {
          return false;
        }
        return s.state != 'running';
      });

  PveNodeOverviewState._();

  factory PveNodeOverviewState(
          [void Function(PveNodeOverviewStateBuilder) updates]) =
      _$PveNodeOverviewState;
  factory PveNodeOverviewState.init(bool standalone) =>
      PveNodeOverviewState((b) => b
        //base
        ..errorMessage = ''
        ..isBlank = true
        ..isLoading = false
        ..isSuccess = false
        //class
        ..standalone = standalone);
}
