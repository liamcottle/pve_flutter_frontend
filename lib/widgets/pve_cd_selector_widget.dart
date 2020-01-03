import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pve_flutter_frontend/bloc/pve_cd_selector_bloc.dart';
import 'package:pve_flutter_frontend/bloc/pve_file_selector_bloc.dart';
import 'package:pve_flutter_frontend/bloc/pve_storage_selector_bloc.dart';
import 'package:pve_flutter_frontend/states/pve_qemu_create_wizard_state.dart';
import 'package:pve_flutter_frontend/widgets/pve_file_selector_widget.dart';
import 'package:proxmox_dart_api_client/proxmox_dart_api_client.dart';

class PveCdSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final client = Provider.of<ProxmoxApiClient>(context);
    final cdBloc = Provider.of<PveCdSelectorBloc>(context);

    return StreamBuilder<PveCdSelectorState>(
        stream: cdBloc.state,
        initialData: cdBloc.state.value,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final state = snapshot.data;
            return Column(children: [
              RadioListTile<CdType>(
                title: const Text('Use CD/DVD disc image file (iso)'),
                value: CdType.iso,
                groupValue: state.value,
                onChanged: (value) => cdBloc.events.add(ChangeValue(value)),
              ),
              if (state.value == CdType.iso)
                OutlineButton(
                  borderSide: state.hasError ? BorderSide(color: Colors.red) : null,
                  child: Text((state.file == null ||state.file.isEmpty) ? "Choose File" : state.file),
                  onPressed: () async {
                    final PveNodesStorageContentModel file = await showDialog(
                        context: context,
                        builder: (context) => PveFileSelector(
                              fBloc: PveFileSelectorBloc(
                                apiClient: client,
                                fileType: PveStorageContentType.iso,
                              ),
                              sBloc: PveStorageSelectorBloc(
                                  apiClient: client,
                                  fetchEnabledStoragesOnly: true,
                                  content: PveStorageContentType.iso)
                                ..events.add(LoadStoragesEvent()),
                            ));
                    if (file != null && file is PveNodesStorageContentModel) {
                      cdBloc.events.add(FileSelected(file.volid));
                    }
                  },
                ),
              RadioListTile<CdType>(
                title: const Text('Use physical CD/DVD Drive'),
                value: CdType.cdrom,
                groupValue: state.value,
                onChanged: (value) => cdBloc.events.add(ChangeValue(value)),
              ),
              RadioListTile<CdType>(
                title: const Text('Do not use any media'),
                value: CdType.none,
                groupValue: state.value,
                onChanged: (value) => cdBloc.events.add(ChangeValue(value)),
              ),
            ]);
          }

          return Container();
        });
  }
}
