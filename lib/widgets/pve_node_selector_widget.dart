import 'package:flutter/material.dart';
import 'package:pve_flutter_frontend/bloc/pve_node_selector_bloc.dart';
import 'package:pve_flutter_frontend/events/pve_node_selector_events.dart';
import 'package:pve_flutter_frontend/models/pve_nodes_model.dart';
import 'package:pve_flutter_frontend/states/pve_node_selector_states.dart';

class PveNodeSelector extends StatefulWidget {
  @override
  _PveNodeSelectorState createState() => _PveNodeSelectorState();
}

class _PveNodeSelectorState extends State<PveNodeSelector> {
  PveNodeSelectorBloc bloc;

  @override
  void initState() {
    super.initState();

    bloc = PveNodeSelectorBloc();
    bloc.events.add(LoadNodesEvent());
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PveNodeSelectorState>(
      stream: bloc.state,
      initialData: InitalState(),
      builder:
          (BuildContext context, AsyncSnapshot<PveNodeSelectorState> snapshot) {
        final state = snapshot.data;
        if (state is LoadedNodesState) {
          final nodes = state.nodes;
          return DropdownButtonFormField(
              decoration: InputDecoration(
                errorText: 'todo',
              ),
              items: <DropdownMenuItem<PveNodesModel>>[
                for (var node in nodes)
                  DropdownMenuItem(
                    child: Row(
                      children: <Widget>[
                        Text(node.nodeName),
                        VerticalDivider(),
                        Text(node.renderMemoryUsagePercent()),
                        VerticalDivider(),
                        Text(node.renderCpuUsage())
                      ],
                    ),
                    value: node,
                  )
              ],
              onChanged: (PveNodesModel selectedNode) => bloc.events.add(NodeSelectedEvent(selectedNode)),
              value: null,
              );
        }

        if (state is LoadedNodesWithSelectionState) {
          final nodes = state.nodes;
          return DropdownButtonFormField(
              decoration: InputDecoration(
                errorText: 'todo',
              ),
              items: <DropdownMenuItem<PveNodesModel>>[
                for (var node in nodes)
                  DropdownMenuItem(
                    child: Row(
                      children: <Widget>[
                        Text(node.nodeName),
                        VerticalDivider(),
                        Text(node.renderMemoryUsagePercent()),
                        VerticalDivider(),
                        Text(node.renderCpuUsage())
                      ],
                    ),
                    value: node,
                  )
              ],
              onChanged: (PveNodesModel selectedNode) => bloc.events.add(NodeSelectedEvent(selectedNode)),
              value: state.selectedNode,
              );
        }

        return Container();
      },
    );
  }
}
