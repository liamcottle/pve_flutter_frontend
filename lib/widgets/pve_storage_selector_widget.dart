import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proxmox_dart_api_client/proxmox_dart_api_client.dart';
import 'package:pve_flutter_frontend/bloc/pve_storage_selector_bloc.dart';
import 'package:pve_flutter_frontend/states/pve_storage_selector_state.dart';
import 'package:pve_flutter_frontend/utils/renderers.dart';
import 'package:pve_flutter_frontend/widgets/proxmox_capacity_indicator.dart';
import 'package:pve_flutter_frontend/widgets/proxmox_stream_builder_widget.dart';

class PveStorageSelectorDropdown extends StatelessWidget {
  final String labelText;
  final PveStorageSelectorBloc sBloc;
  final bool allowBlank;
  const PveStorageSelectorDropdown({
    Key key,
    this.labelText,
    this.sBloc,
    this.allowBlank = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _pveStorageSelectorBloc =
        sBloc ?? Provider.of<PveStorageSelectorBloc>(context);
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
                child: ListTile(
                  title: Text(storage.id),
                  leading: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Color.fromARGB(255, 243, 246, 255)),
                    child: Center(
                        child: Text(
                      storage.type.toUpperCase(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 14),
                    )),
                  ),
                  subtitle: ProxmoxCapacityIndicator(
                    usedValue: Renderers.formatSize(storage.usedSpace),
                    usedPercent: storage.usedPercent,
                    totalValue: Renderers.formatSize(storage.totalSpace),
                    selected: false,
                  ),
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
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (state.errorMessage.isNotEmpty) {
              return state.errorMessage;
            }
            if (value == null && !allowBlank) {
              return 'Selection required';
            }
            return null;
          },
        );
      },
    );
  }
}
