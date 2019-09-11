import 'package:pve_flutter_frontend/models/pve_nodes_model.dart';

abstract class PveNodeSelectorState {}

class InitalState extends PveNodeSelectorState {}

class LoadedNodesState extends PveNodeSelectorState {
final List<PveNodesModel> nodes;

  LoadedNodesState(this.nodes);

}

class LoadedNodesWithSelectionState extends PveNodeSelectorState {
final List<PveNodesModel> nodes;
final PveNodesModel selectedNode;

  LoadedNodesWithSelectionState({this.nodes, this.selectedNode});

}

class ErrorState extends PveNodeSelectorState {}
