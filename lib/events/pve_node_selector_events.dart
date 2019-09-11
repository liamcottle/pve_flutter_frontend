import 'package:pve_flutter_frontend/models/pve_nodes_model.dart';

abstract class PveNodeSelectorEvent {}

class LoadNodesEvent extends PveNodeSelectorEvent {}

class NodeSelectedEvent extends PveNodeSelectorEvent {
  final PveNodesModel node;

  NodeSelectedEvent(this.node);

}