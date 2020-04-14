import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proxmox_dart_api_client/proxmox_dart_api_client.dart';
import 'package:pve_flutter_frontend/bloc/pve_storage_selector_bloc.dart';
import 'package:pve_flutter_frontend/states/pve_storage_selector_state.dart';
import 'package:pve_flutter_frontend/widgets/proxmox_stream_builder_widget.dart';

class PveStorageSelector extends StatelessWidget {
  final String labelText;

  const PveStorageSelector({Key key, this.labelText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _pveStorageSelectorBloc =
        Provider.of<PveStorageSelectorBloc>(context);
    return ProxmoxStreamBuilder<PveStorageSelectorBloc,
        PveStorageSelectorState>(
      bloc: _pveStorageSelectorBloc,
      builder: (BuildContext context, state) {
        return DropdownButtonFormField(
          decoration: InputDecoration(
            labelText: labelText,
            helperText: ' ',
          ),
          items: <DropdownMenuItem<PveNodesStorageModel>>[
            for (var storage in state?.storages)
              DropdownMenuItem(
                child: Row(
                  children: <Widget>[
                    Text(storage.id),
                    VerticalDivider(),
                    Text(storage.type),
                    VerticalDivider(),
                    Text(storage.usedPercent.toString())
                  ],
                ),
                value: storage,
              )
          ],
          onChanged: (PveNodesStorageModel selectedStorage) =>
              _pveStorageSelectorBloc.events
                  .add(StorageSelectedEvent(storage: selectedStorage)),
          selectedItemBuilder: (context) =>
              state.storages.map((item) => Text(item.id)).toList(),
          value: state.selected,
          autovalidate: true,
          validator: (_) {
            return state.errorMessage;
          },
        );
      },
    );
  }
}
