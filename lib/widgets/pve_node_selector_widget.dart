import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pve_flutter_frontend/bloc/pve_node_selector_bloc.dart';
import 'package:pve_flutter_frontend/models/pve_nodes_model.dart';

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
        if (snapshot.hasData && snapshot.data.nodes != null) {
          final state = snapshot.data;

          return DropdownButtonFormField(
            decoration: InputDecoration(
              labelText: labelText,
              helperText: ' ',
            ),
            items: state.nodes
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
                      value: item,
                    ))
                .toList(),
            selectedItemBuilder: (context) =>
                state.nodes.map((item) => Text(item.nodeName)).toList(),
            onChanged: (PveNodesModel selectedNode) => _pveNodeSelectorBloc
                .events
                .add(NodeSelectedEvent(selectedNode)),
            value: state.value,
            autovalidate: true,
            validator: (_) {
              return state?.errorText;
            },
          );
        }

        return Container();
      },
    );
  }
}
