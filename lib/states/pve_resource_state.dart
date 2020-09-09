import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:proxmox_dart_api_client/proxmox_dart_api_client.dart';
import 'package:pve_flutter_frontend/states/pve_base_state.dart';

part 'pve_resource_state.g.dart';

abstract class PveResourceState
    with PveBaseState
    implements Built<PveResourceState, PveResourceStateBuilder> {
  // Fields
  BuiltSet<PveClusterResourcesModel> get resources;

  BuiltSet<String> get typeFilter;
  BuiltSet<String> get subFilter;
  BuiltSet<String> get nodeFilter;
  BuiltSet<String> get poolFilter;
  BuiltSet<PveResourceStatusType> get statusFilter;
  String get nameFilter;

  Iterable<PveClusterResourcesModel> get filterResources =>
      resources.where((r) {
        var include = true;
        if (typeFilter.isNotEmpty) {
          include &= typeFilter.contains(r.type);
        }
        if (subFilter.isNotEmpty) {
          include &= subFilter.contains(r.level);
        }
        if (nodeFilter.isNotEmpty) {
          include &= nodeFilter.contains(r.node);
        }
        if (poolFilter.isNotEmpty) {
          include &= poolFilter.contains(r.pool);
        }
        if (statusFilter.isNotEmpty) {
          include &= statusFilter.contains(r.getStatus());
        }
        if (nameFilter.isNotEmpty) {
          include &= r.displayName.contains(nameFilter);
        }
        return include;
      });
  Iterable<PveClusterResourcesModel> get nodes =>
      resources.where((element) => element.type == "node");
  Iterable<PveClusterResourcesModel> get vms =>
      resources.where((element) => element.type == "qemu");
  Iterable<PveClusterResourcesModel> get container =>
      resources.where((element) => element.type == "lxc");
  Iterable<PveClusterResourcesModel> get storages =>
      resources.where((element) => element.type == "storage");

  PveClusterResourcesModel resourceByID(String id) =>
      resources.singleWhere((element) => element.id == id);

  bool get isStandalone => nodes.length < 2;

  PveResourceState._();

  factory PveResourceState([void Function(PveResourceStateBuilder) updates]) =
      _$PveResourceState;

  factory PveResourceState.init() => PveResourceState((b) => b
    //base
    ..errorMessage = ''
    ..isBlank = true
    ..isLoading = false
    ..isSuccess = false
    //class
    ..nameFilter = '');
}
