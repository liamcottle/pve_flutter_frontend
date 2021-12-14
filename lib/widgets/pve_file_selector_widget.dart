import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:proxmox_dart_api_client/proxmox_dart_api_client.dart';
import 'package:pve_flutter_frontend/bloc/pve_file_selector_bloc.dart';
import 'package:pve_flutter_frontend/bloc/pve_storage_selector_bloc.dart';
import 'package:pve_flutter_frontend/states/pve_file_selector_state.dart';
import 'package:pve_flutter_frontend/states/pve_storage_selector_state.dart';

import 'package:pve_flutter_frontend/utils/proxmox_layout_builder.dart';
import 'package:pve_flutter_frontend/utils/renderers.dart';
import 'package:pve_flutter_frontend/widgets/proxmox_capacity_indicator.dart';
import 'package:pve_flutter_frontend/widgets/proxmox_stream_builder_widget.dart';
import 'package:pve_flutter_frontend/widgets/proxmox_stream_listener.dart';

class PveFileSelector extends StatefulWidget {
  final PveFileSelectorBloc? fBloc;
  final PveStorageSelectorBloc? sBloc;
  final bool isSelector;

  const PveFileSelector({
    Key? key,
    this.fBloc,
    this.sBloc,
    this.isSelector = false,
  }) : super(key: key);
  @override
  _PveFileSelectorState createState() => _PveFileSelectorState();
}

class _PveFileSelectorState extends State<PveFileSelector> {
  @override
  Widget build(BuildContext context) {
    return ProxmoxLayoutBuilder(
      builder: (context, layout) => Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text("Storage"),
        ),
        body: PveFileSelectorWidget(
          isSelector: widget.isSelector,
          fBloc: widget.fBloc,
          sBloc: widget.sBloc,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    widget.fBloc!.dispose();
    widget.sBloc!.dispose();
  }
}

class PveFileSelectorWidget extends StatelessWidget {
  final PveFileSelectorBloc? fBloc;
  final PveStorageSelectorBloc? sBloc;
  final bool isSelector;

  const PveFileSelectorWidget({
    Key? key,
    required this.fBloc,
    required this.sBloc,
    this.isSelector = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamListener<PveStorageSelectorState>(
      stream: sBloc!.state,
      onStateChange: (storageSelectorState) {
        fBloc!.events.add(ChangeStorage(storageSelectorState.selected?.id));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Container(
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
            Expanded(
              child: StreamBuilder<PveFileSelectorState>(
                  stream: fBloc!.state,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final state = snapshot.data!;
                      return Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Content",
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                    fontWeight: FontWeight.bold),
                              ),
                              Row(
                                children: <Widget>[
                                  IconButton(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground,
                                    icon: Icon(Icons.search),
                                    onPressed: () =>
                                        fBloc!.events.add(ToggleSearch()),
                                  ),
                                  IconButton(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground,
                                    icon: Icon(
                                      state.gridView
                                          ? Icons.view_list
                                          : Icons.view_module,
                                    ),
                                    onPressed: () =>
                                        fBloc!.events.add(ToggleGridListView()),
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
                              onChanged: (searchTerm) => fBloc!.events
                                  .add(FilterContent(searchTerm: searchTerm)),
                            ),
                          Expanded(
                              child: FileSelectorContentView(
                            isSelector: isSelector,
                            gridView: state.gridView,
                            content: state.content.toList(),
                            storageSelected: state.storageID != null,
                          ))
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
      ),
    );
  }
}

class PveStorageCardIcon extends StatelessWidget {
  final bool selected;
  final IconData? icon;

  const PveStorageCardIcon({Key? key, this.selected = false, this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 50,
      child: Card(
        color: Theme.of(context).colorScheme.secondary,
        elevation: 0,
        child: Icon(icon),
      ),
    );
  }
}

class PveStorageCard extends StatelessWidget {
  const PveStorageCard({
    Key? key,
    required this.isSelected,
    required this.sBloc,
    required this.storage,
    required this.storageIcon,
    this.width = 300,
  }) : super(key: key);

  final bool isSelected;
  final PveStorageSelectorBloc? sBloc;
  final PveNodesStorageModel storage;
  final Widget storageIcon;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surface,
          elevation: isSelected ? 4 : 1,
          child: InkWell(
              onTap: storage.active!
                  ? () {
                      sBloc!.events.add(StorageSelectedEvent(storage: storage));
                    }
                  : null,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: storageIcon,
                      ),
                      Text(
                        storage.id,
                        style: TextStyle(
                            color: isSelected
                                ? Theme.of(context).colorScheme.onPrimary
                                : Theme.of(context).colorScheme.onBackground,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "(${storage.content})",
                        style: TextStyle(
                          color: (isSelected
                                  ? Theme.of(context).colorScheme.onPrimary
                                  : Theme.of(context).colorScheme.onBackground)
                              .withOpacity(0.75),
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                      ),
                      if (storage.active!)
                        Expanded(
                          child: Align(
                            alignment: FractionalOffset.bottomCenter,
                            child: ProxmoxCapacityIndicator(
                              usedValue:
                                  Renderers.formatSize(storage.usedSpace),
                              usedPercent: storage.usedPercent,
                              totalValue:
                                  Renderers.formatSize(storage.totalSpace),
                              selected: isSelected,
                            ),
                          ),
                        ),
                      if (!storage.active!)
                        Expanded(
                          child: Align(
                            alignment: FractionalOffset.bottomCenter,
                            child: Text(
                              "Storage offline",
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onBackground
                                    .withOpacity(0.75),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ]),
              )),
        ),
      ),
    );
  }
}

class FileSelectorContentView extends StatelessWidget {
  final bool? gridView;
  final List<PveNodesStorageContentModel>? content;
  final bool isSelector;
  final bool storageSelected;

  const FileSelectorContentView({
    Key? key,
    this.gridView,
    this.content,
    this.isSelector = false,
    this.storageSelected = false,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (content == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    if (content!.isEmpty && storageSelected) {
      return Center(
        child: Text("Nothing found"),
      );
    }

    if (content!.isEmpty && !storageSelected) {
      return Center(
        child: Text("Please select a storage"),
      );
    }

    if (gridView!) {
      return ProxmoxLayoutBuilder(builder: (context, layout) {
        final wide = layout != ProxmoxLayout.slim;
        return GridView.builder(
          itemCount: content!.length,
          itemBuilder: (context, index) => GridTile(
            child: Card(
              child: InkWell(
                onTap: isSelector
                    ? () => Navigator.pop(context, content![index])
                    : null,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      getContentIcon(content![index].content),
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    FractionallySizedBox(
                      widthFactor: 0.8,
                      child: Text(
                        Renderers.renderStorageContent(content![index]),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(Renderers.formatSize(content![index].size))
                  ],
                ),
              ),
            ),
          ),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: wide ? 5 : 3),
        );
      });
    }

    return ListView.builder(
      itemCount: content!.length,
      itemBuilder: (context, index) => Card(
        child: ListTile(
          leading: Icon(
            getContentIcon(content![index].content),
            color: Theme.of(context).colorScheme.secondary,
          ),
          title: Text(
            Renderers.renderStorageContent(content![index]),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Text(Renderers.formatSize(content![index].size)),
          onTap:
              isSelector ? () => Navigator.pop(context, content![index]) : null,
        ),
      ),
    );
  }

  IconData getContentIcon(PveStorageContentType? content) {
    switch (content) {
      case PveStorageContentType.iso:
        return FontAwesomeIcons.compactDisc;
        break;
      case PveStorageContentType.vztmpl:
        return FontAwesomeIcons.cube;
        break;
      case PveStorageContentType.images:
        return FontAwesomeIcons.hdd;
        break;
      case PveStorageContentType.rootdir:
        return FontAwesomeIcons.solidHdd;
        break;
      case PveStorageContentType.backup:
        return FontAwesomeIcons.save;
        break;
      default:
        return FontAwesomeIcons.questionCircle;
    }
  }
}
