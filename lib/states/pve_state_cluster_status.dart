import 'package:built_value/built_value.dart';
import 'package:built_collection/built_collection.dart';
import 'package:proxmox_dart_api_client/proxmox_dart_api_client.dart';
part 'pve_state_cluster_status.g.dart';

abstract class PveClusterStatusState
    implements Built<PveClusterStatusState, PveClusterStatusStateBuilder> {
  PveClusterStatusState._();
  factory PveClusterStatusState(
          [void Function(PveClusterStatusStateBuilder) updates]) =
      _$PveClusterStatusState;

  BuiltList<PveClusterStatusModel> get model;

  List<PveClusterStatusModel> get nodes => model.where((model)=> model.type == 'node').toList();

  PveClusterStatusModel get cluster => model.singleWhere((model)=> model.type == 'cluster');

  bool get healthy => !nodes.any((node) => !node.online);
}
