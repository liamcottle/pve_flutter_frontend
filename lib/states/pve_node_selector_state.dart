import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:meta/meta.dart';
import 'package:proxmox_dart_api_client/proxmox_dart_api_client.dart';
import 'package:pve_flutter_frontend/states/pve_base_state.dart';

part 'pve_node_selector_state.g.dart';

abstract class PveNodeSelectorState
    with PveBaseState
    implements Built<PveNodeSelectorState, PveNodeSelectorStateBuilder> {
  // Fields
  PveNodesModel? get selectedNode;

  List<PveNodesModel> get availableNodes {
    return nodes.where((element) {
      var include = true;
      if (allowedNodes.isNotEmpty) {
        include &= allowedNodes.contains(element.nodeName);
      }
      if (disallowedNodes.isNotEmpty) {
        include &= !disallowedNodes.contains(element.nodeName);
      }
      if (onlineValidator) {
        include &= element.status == 'online';
      }
      return include;
    }).toList();
  }

  BuiltList<PveNodesModel> get nodes;

  bool get onlineValidator;

  BuiltSet<String> get allowedNodes;

  BuiltSet<String> get disallowedNodes;

  PveNodeSelectorState._();

  factory PveNodeSelectorState(
          [void Function(PveNodeSelectorStateBuilder) updates]) =
      _$PveNodeSelectorState;

  factory PveNodeSelectorState.init({required bool onlineValidator}) =>
      PveNodeSelectorState((b) => b
        //base
        ..errorMessage = ''
        ..isBlank = true
        ..isLoading = false
        ..isSuccess = false
        //class
        ..onlineValidator = onlineValidator);
}
