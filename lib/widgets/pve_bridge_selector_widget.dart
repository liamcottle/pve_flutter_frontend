import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/streams.dart' show ValueStreamExtensions;
import 'package:proxmox_dart_api_client/proxmox_dart_api_client.dart';
import 'package:pve_flutter_frontend/bloc/pve_bridge_selector_bloc.dart';

class PveBridgeSelector extends StatelessWidget {
  final String labelText;

  const PveBridgeSelector({Key key, this.labelText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _bBloc = Provider.of<PveBridgeSelectorBloc>(context);
    return StreamBuilder<PveBridgeSelectorState>(
      stream: _bBloc.state,
      initialData: _bBloc.state.value,
      builder: (BuildContext context,
          AsyncSnapshot<PveBridgeSelectorState> snapshot) {
        if (snapshot.hasData) {
          final state = snapshot.data;

          return DropdownButtonFormField(
            decoration: InputDecoration(
              labelText: labelText,
              helperText: ' ',
            ),
            items: <DropdownMenuItem<PveNodeNetworkModel>>[
              for (var bridge in state?.bridges)
                DropdownMenuItem(
                  child: Row(
                    children: <Widget>[
                      Text(bridge.iface ?? ''),
                      VerticalDivider(),
                      Text(bridge.active?.toString() ?? ''),
                      VerticalDivider(),
                      Text(bridge.comment ?? '')
                    ],
                  ),
                  value: bridge,
                )
            ],
            onChanged: (PveNodeNetworkModel selection) =>
                _bBloc.events.add(BridgeSelectedEvent(selection)),
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
