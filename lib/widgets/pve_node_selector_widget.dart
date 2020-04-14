import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proxmox_dart_api_client/proxmox_dart_api_client.dart';
import 'package:pve_flutter_frontend/bloc/pve_node_selector_bloc.dart';
import 'package:pve_flutter_frontend/states/pve_node_selector_state.dart';

class PveNodeSelector extends StatelessWidget {
  final String labelText;

  const PveNodeSelector({Key key, this.labelText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _pveNodeSelectorBloc = Provider.of<PveNodeSelectorBloc>(context);
    return StreamBuilder<PveNodeSelectorState>(
      stream: _pveNodeSelectorBloc.state,
      initialData: _pveNodeSelectorBloc.state.value,
      builder:
          (BuildContext context, AsyncSnapshot<PveNodeSelectorState> snapshot) {
        if (snapshot.hasData && snapshot.data.availableNodes.isNotEmpty) {
          final state = snapshot.data;

          return DropdownButton(
            items: state.availableNodes
                .map((item) => DropdownMenuItem(
                      child: Row(
                        children: <Widget>[
                          Text(item.nodeName),
                          VerticalDivider(),
                          Text(item.renderMemoryUsagePercent()),
                          VerticalDivider(),
                          Text(item.renderCpuUsage())
                        ],
                      ),
                      value: item.nodeName,
                    ))
                .toList(),
            selectedItemBuilder: (context) => state.availableNodes
                .map((item) => Text(item.nodeName))
                .toList(),
            onChanged: (String selectedNode) => _pveNodeSelectorBloc.events
                .add(NodeSelectedEvent(selectedNode)),
            value: state.selectedNode.nodeName,
          );
        }

        return Container();
      },
    );
  }
}
