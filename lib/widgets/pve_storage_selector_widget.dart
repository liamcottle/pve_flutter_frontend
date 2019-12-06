import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pve_flutter_frontend/bloc/pve_storage_selector_bloc.dart';
import 'package:pve_flutter_frontend/models/pve_nodes_storage_model.dart';

class PveStorageSelector extends StatelessWidget {
  final String labelText;

  const PveStorageSelector({Key key, this.labelText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _pveStorageSelectorBloc =
        Provider.of<PveStorageSelectorBloc>(context);
    return StreamBuilder<PveStorageSelectorState>(
      stream: _pveStorageSelectorBloc.state,
      initialData: _pveStorageSelectorBloc.state.value,
      builder: (BuildContext context,
          AsyncSnapshot<PveStorageSelectorState> snapshot) {
        final state = snapshot.data;

        if (state.storages != null) {
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
                    .add(StorageSelectedEvent(selectedStorage)),
            selectedItemBuilder: (context) =>
                state.storages.map((item) => Text(item.id)).toList(),
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
