import 'package:built_value/built_value.dart';
import 'package:built_collection/built_collection.dart';
import 'package:proxmox_dart_api_client/proxmox_dart_api_client.dart';
import 'package:pve_flutter_frontend/states/pve_base_state.dart';
part 'pve_cluster_status_state.g.dart';

abstract class PveClusterStatusState
    with PveBaseState
    implements Built<PveClusterStatusState, PveClusterStatusStateBuilder> {
  PveClusterStatusState._();
  factory PveClusterStatusState(
          [void Function(PveClusterStatusStateBuilder) updates]) =
      _$PveClusterStatusState;

  BuiltList<PveClusterStatusModel> get model;

  List<PveClusterStatusModel> get nodes =>
      model.where((model) => model.type == 'node').toList();

  PveClusterStatusModel get cluster =>
      model.singleWhere((model) => model.type == 'cluster', orElse: () => null);

  bool get healthy => !nodes.any((node) => !node.online);

  bool get missingSubscription => nodes.any((node) => node.level == '');
  factory PveClusterStatusState.init() => PveClusterStatusState((b) => b
        //base
        ..errorMessage = ''
        ..isBlank = true
        ..isLoading = false
        ..isSuccess = false
      //class
      );
}
