import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:proxmox_dart_api_client/proxmox_dart_api_client.dart';
import 'package:pve_flutter_frontend/bloc/pve_file_selector_bloc.dart';
import 'package:pve_flutter_frontend/bloc/pve_storage_selector_bloc.dart';
import 'package:pve_flutter_frontend/states/pve_file_selector_state.dart';
import 'package:pve_flutter_frontend/states/pve_storage_selector_state.dart';
import 'package:pve_flutter_frontend/utils/renderers.dart';
import 'package:pve_flutter_frontend/utils/utils.dart';
import 'package:pve_flutter_frontend/utils/validators.dart';
import 'package:pve_flutter_frontend/widgets/proxmox_stream_builder_widget.dart';
import 'package:pve_flutter_frontend/widgets/proxmox_stream_listener.dart';
import 'package:pve_flutter_frontend/widgets/pve_file_selector_widget.dart';
import 'package:pve_flutter_frontend/widgets/pve_storage_selector_widget.dart';

class PveGuestBackupWidget extends StatelessWidget {
  final String guestID;

  const PveGuestBackupWidget({Key? key, required this.guestID})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sBloc = Provider.of<PveStorageSelectorBloc>(context);
    final fBloc = Provider.of<PveFileSelectorBloc>(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Backup",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          StreamListener<PveStorageSelectorState>(
            stream: sBloc.state,
            onStateChange: (storageSelectorState) {
              fBloc.events
                  .add(ChangeStorage(storageSelectorState.selected?.id));
            },
            child: Container(
              height: 170,
              child: ProxmoxStreamBuilder<PveStorageSelectorBloc,
                      PveStorageSelectorState>(
                  bloc: sBloc,
                  builder: (context, state) {
                    if (state.isLoading) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (state.storages.length > 1) {
                      return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: state.storages.length,
                          itemBuilder: (context, index) {
                            var storage = state.storages[index];
                            var isSelected = storage.id == state.selected?.id;
                            var storageIcon =
                                Renderers.getStorageIcon(storage.type);
                            return PveStorageCard(
                              isSelected: isSelected,
                              sBloc: sBloc,
                              storage: storage,
                              storageIcon: PveStorageCardIcon(
                                icon: storageIcon,
                                selected: isSelected,
                              ),
                            );
                          });
                    }
                    if (state.storages.length == 1) {
                      var storage = state.storages[0];
                      var isSelected = storage.id == state.selected?.id;
                      var storageIcon = Renderers.getStorageIcon(storage.type);
                      return PveStorageCard(
                        isSelected: isSelected,
                        sBloc: sBloc,
                        storage: storage,
                        storageIcon: PveStorageCardIcon(
                          icon: storageIcon,
                          selected: isSelected,
                        ),
                        width: MediaQuery.of(context).size.width * 0.9,
                      );
                    }
                    return Center(
                      child: Text('No storage available'),
                    );
                  }),
            ),
          ),
          Expanded(
            child: StreamBuilder<PveFileSelectorState>(
                stream: fBloc.state,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final state = snapshot.data!;
                    return Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Recent backups",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 159, 171, 207),
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                IconButton(
                                  color: Color.fromARGB(255, 152, 162, 201),
                                  icon: Icon(Icons.search),
                                  onPressed: () =>
                                      fBloc.events.add(ToggleSearch()),
                                ),
                              ],
                            )
                          ],
                        ),
                        if (state.search)
                          TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Search',
                            ),
                            autofocus: true,
                            onChanged: (searchTerm) => fBloc.events
                                .add(FilterContent(searchTerm: searchTerm)),
                          ),
                        Expanded(
                          child: PveGuestBackupContent(
                            content: state.content.toList(),
                            storageSelected: state.storageID != null,
                          ),
                        )
                      ],
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.save),
        onPressed: () async {
          await Navigator.of(context)
              .push(_createBackupNowRoute(sBloc, guestID));
          fBloc.events.add(LoadStorageContent());
        },
        label: Text("Backup now"),
      ),
    );
  }

  Route _createBackupNowRoute(PveStorageSelectorBloc sBloc, String guestID) {
    return MaterialPageRoute(
        builder: (context) => PveBackupForm(
              sBloc: sBloc,
              guestID: guestID,
            ));
  }
}

class PveGuestBackupContent extends StatelessWidget {
  final List<PveNodesStorageContentModel>? content;
  final bool? storageSelected;

  const PveGuestBackupContent({
    Key? key,
    this.content,
    this.storageSelected,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final fBloc = Provider.of<PveFileSelectorBloc>(context);

    if (content == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    if (content!.isEmpty && storageSelected!) {
      return Center(
        child: Text("no backup file found"),
      );
    }

    if (content!.isEmpty && !storageSelected!) {
      return Center(
        child: Text("please select storage"),
      );
    }

    return ListView.builder(
      itemCount: content!.length,
      itemBuilder: (context, index) => Card(
        child: ListTile(
          leading: Icon(
            FontAwesomeIcons.save,
            color: Color.fromARGB(255, 152, 162, 201),
          ),
          title: Text(
            Renderers.renderStorageContent(content![index]),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Row(
            children: [Text(Renderers.formatSize(content![index].size))],
          ),
          trailing: Icon(Icons.more_vert),
          onTap: () => _createBackupOptionsSheet(
              context, content![index].volid, content![index].size, fBloc),
        ),
      ),
    );
  }

  Future<T?> _createBackupOptionsSheet<T>(BuildContext context, String? volid,
      int? filesize, PveFileSelectorBloc fBloc) async {
    return await showModalBottomSheet(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    width: 40,
                    height: 3,
                    color: Colors.black,
                  ),
                ),
              ),
              ListTile(
                title: Text("Selection:"),
                subtitle: Text(volid!),
                trailing: Text(Renderers.formatSize(filesize)),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView(children: [
                    OutlineButton.icon(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      onPressed: null,
                      icon: Icon(Icons.restore),
                      label: Text("Restore"),
                    ),
                    OutlineButton.icon(
                      onPressed: () async {
                        final guard = await (_showConfirmDialog(
                                context,
                                'Attention',
                                'Do you really want to delete this backup?')
                            as FutureOr<bool>);
                        if (guard) {
                          fBloc.events.add(DeleteFile(volid));
                          Navigator.of(context).pop();
                        }
                      },
                      icon: Icon(Icons.delete),
                      label: Text("Remove"),
                    ),
                    OutlineButton.icon(
                      onPressed: () =>
                          _showConfigurationDialog(context, fBloc, volid),
                      icon: Icon(Icons.featured_play_list),
                      label: Text("Show Configuration"),
                    ),
                  ]),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Future<bool?> _showConfirmDialog(
      BuildContext context, String title, String body) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'Cancel',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          FlatButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              'Confirm',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _showConfigurationDialog(
      BuildContext context, PveFileSelectorBloc fBloc, String? volume) async {
    return await showDialog(
      context: context,
      builder: (context) => PveConfigurationDialog(
        apiClient: fBloc.apiClient,
        targetNode: fBloc.latestState.nodeID,
        volume: volume,
      ),
    );
  }
}

class PveConfigurationDialog extends StatefulWidget {
  final ProxmoxApiClient apiClient;
  final String targetNode;
  final String? volume;

  const PveConfigurationDialog({
    Key? key,
    required this.apiClient,
    required this.targetNode,
    required this.volume,
  }) : super(key: key);
  @override
  _PveConfigurationDialogState createState() => _PveConfigurationDialogState();
}

class _PveConfigurationDialogState extends State<PveConfigurationDialog> {
  Future<String?>? configuration;
  @override
  void initState() {
    super.initState();
    configuration = widget.apiClient
        .getNodesVZDumpExtractConfig(widget.targetNode, widget.volume!);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: configuration,
      builder: (context, snapshot) => AlertDialog(
        insetPadding: EdgeInsets.all(4),
        title: Text("Configuration"),
        content: snapshot.hasData
            ? SingleChildScrollView(child: Text(snapshot.data as String))
            : Center(
                child: CircularProgressIndicator(),
              ),
        actions: [
          FlatButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              'Close',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}

class PveBackupForm extends StatefulWidget {
  final PveStorageSelectorBloc sBloc;
  final String guestID;

  const PveBackupForm({Key? key, required this.sBloc, required this.guestID})
      : super(key: key);

  @override
  _PveBackupFormState createState() => _PveBackupFormState();
}

class _PveBackupFormState extends State<PveBackupForm> {
  PveVZDumpModeType? mode = PveVZDumpModeType.suspend;
  PveVZDumpCompressionType? compression = PveVZDumpCompressionType.zstd;
  static const compTypes = [
    {'type': PveVZDumpCompressionType.none, 'name': 'none'},
    {'type': PveVZDumpCompressionType.gzip, 'name': 'GZIP (good)'},
    {'type': PveVZDumpCompressionType.lzo, 'name': 'LZO (fast)'},
    {'type': PveVZDumpCompressionType.zstd, 'name': 'ZSTD (fast & good)'}
  ];
  TextEditingController? emailToController;
  bool enableSubmitButton = true;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    emailToController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Schedule backup",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
          padding: EdgeInsets.all(8),
          child: Form(
            key: _formKey,
            onChanged: () {
              final isValid = _formKey.currentState!.validate();
              setState(() {
                enableSubmitButton = isValid;
              });
            },
            child: Column(
              children: [
                PveStorageSelectorDropdown(
                  labelText: 'Storage',
                  sBloc: widget.sBloc,
                  allowBlank: false,
                ),
                _createModeDropdown(),
                _createCompressionDropdown(),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Email to',
                    helperText: ' ',
                  ),
                  controller: emailToController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value!.isNotEmpty && !Validators.isValidEmail(value)) {
                      return 'Please enter valid email address';
                    }
                    return null;
                  },
                ),
                OutlineButton.icon(
                    onPressed: enableSubmitButton
                        ? () {
                            //TODO remove when async validation is implemented
                            if (!_formKey.currentState!.validate()) {
                              setState(() {
                                enableSubmitButton = false;
                              });
                              return;
                            }

                            startBackup(
                              widget.sBloc.apiClient,
                              widget.sBloc.latestState.nodeID,
                              widget.sBloc.latestState.selected!.id,
                              widget.guestID,
                              compression,
                              mode!,
                              mailTo: emailToController!.text,
                            );
                          }
                        : null,
                    icon: Icon(Icons.save),
                    label: Text('Start backup now'))
              ],
            ),
          )),
    );
  }

  Future<void> startBackup(
    ProxmoxApiClient apiClient,
    String node,
    String storage,
    String guestId,
    PveVZDumpCompressionType? compression,
    PveVZDumpModeType mode, {
    String? mailTo,
  }) async {
    try {
      final jobId = await (apiClient.nodesVZDumpCreateBackup(
          node, storage, guestId,
          compressionType: compression,
          mode: mode,
          mailTo: mailTo) as FutureOr<String>);

      await showTaskLogBottomSheet(context, apiClient, node, jobId,
          icon: Icon(Icons.save), jobTitle: Text('Backup $guestId'));
      Navigator.of(context).pop();
    } on ProxmoxApiException catch (e) {
      _scaffoldKey.currentState!.showSnackBar(SnackBar(
        content: Text(
          e.message,
          style: ThemeData.dark().textTheme.button,
        ),
        backgroundColor: ThemeData.dark().errorColor,
      ));
    } catch (e) {
      _scaffoldKey.currentState!.showSnackBar(
        SnackBar(
          content: Text(
            "Error: Could not start backup",
            style: ThemeData.dark().textTheme.button,
          ),
          backgroundColor: ThemeData.dark().errorColor,
        ),
      );
    }
  }

  Widget _createModeDropdown() {
    return DropdownButtonFormField(
      decoration: InputDecoration(
        labelText: 'Mode',
        helperText: ' ',
      ),
      items: <DropdownMenuItem<PveVZDumpModeType>>[
        for (var mode in PveVZDumpModeType.values)
          DropdownMenuItem(
            child: Text(mode.name.toUpperCase()),
            value: mode,
          )
      ],
      onChanged: (PveVZDumpModeType? selection) => setState(() {
        mode = selection;
      }),
      value: mode,
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget _createCompressionDropdown() {
    return DropdownButtonFormField(
      decoration: InputDecoration(
        labelText: 'Compression',
        helperText: ' ',
      ),
      items: <DropdownMenuItem<PveVZDumpCompressionType>>[
        for (var comp in compTypes)
          DropdownMenuItem(
            child: Text(comp['name'] as String),
            value: comp['type'] as PveVZDumpCompressionType?,
          )
      ],
      onChanged: (PveVZDumpCompressionType? selection) => setState(() {
        compression = selection;
      }),
      value: compression,
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }
}
