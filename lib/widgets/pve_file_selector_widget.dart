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
  final PveFileSelectorBloc fBloc;
  final PveStorageSelectorBloc sBloc;
  final bool isSelector;

  const PveFileSelector({
    Key key,
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
      builder: (context, layout) => layout != ProxmoxLayout.slim
          ? Center(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.5,
                width: MediaQuery.of(context).size.width * 0.8,
                child: Card(
                  color: Color.fromARGB(255, 243, 246, 255),
                  child: PveFileSelectorWidget(
                    isSelector: widget.isSelector,
                    fBloc: widget.fBloc,
                    sBloc: widget.sBloc,
                  ),
                ),
              ),
            )
          : Scaffold(
              appBar: AppBar(
                iconTheme: IconThemeData(color: Colors.black),
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: Text(
                  "Storage",
                  style: TextStyle(
                      // fontSize: 30,
                      // fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
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
    widget.fBloc.dispose();
    widget.sBloc.dispose();
  }
}

class PveFileSelectorWidget extends StatelessWidget {
  final PveFileSelectorBloc fBloc;
  final PveStorageSelectorBloc sBloc;
  final bool isSelector;

  const PveFileSelectorWidget({
    Key key,
    @required this.fBloc,
    @required this.sBloc,
    this.isSelector,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamListener<PveStorageSelectorState>(
      stream: sBloc.state,
      onStateChange: (storageSelectorState) {
        fBloc.events.add(ChangeStorage(storageSelectorState.selected?.id));
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
                  stream: fBloc.state,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final state = snapshot.data;
                      return Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Content",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 159, 171, 207),
                                    fontWeight: FontWeight.bold),
                              ),
                              Row(
                                children: <Widget>[
                                  IconButton(
                                    color: Color.fromARGB(255, 152, 162, 201),
                                    icon: Icon(Icons.search),
                                    onPressed: () =>
                                        fBloc.events.add(ToggleSearch()),
                                  ),
                                  IconButton(
                                    color: Color.fromARGB(255, 152, 162, 201),
                                    icon: Icon(
                                      state.gridView
                                          ? Icons.view_list
                                          : Icons.view_module,
                                    ),
                                    onPressed: () =>
                                        fBloc.events.add(ToggleGridListView()),
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
  final IconData icon;

  const PveStorageCardIcon({Key key, this.selected, this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 50,
      child: Card(
        color: selected ? Colors.white : Color.fromARGB(255, 243, 246, 255),
        elevation: 0,
        child: Icon(icon),
      ),
    );
    ;
  }
}

class PveStorageCard extends StatelessWidget {
  const PveStorageCard({
    Key key,
    @required this.isSelected,
    @required this.sBloc,
    @required this.storage,
    @required this.storageIcon,
    this.width = 300,
  }) : super(key: key);

  final bool isSelected;
  final PveStorageSelectorBloc sBloc;
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
          color: isSelected ? Theme.of(context).primaryColor : Colors.white,
          elevation: isSelected ? 4 : 1,
          child: InkWell(
              onTap: () {
                sBloc.events.add(StorageSelectedEvent(storage: storage));
              },
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
                            color: isSelected ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "(${storage.content})",
                        style: TextStyle(
                          color: isSelected ? Colors.white54 : Colors.black54,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: FractionalOffset.bottomCenter,
                          child: ProxmoxCapacityIndicator(
                            usedValue: Renderers.formatSize(storage.usedSpace),
                            usedPercent: storage.usedPercent,
                            totalValue:
                                Renderers.formatSize(storage.totalSpace),
                            selected: isSelected,
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
  final bool gridView;
  final List<PveNodesStorageContentModel> content;
  final bool isSelector;
  final bool storageSelected;

  const FileSelectorContentView(
      {Key key,
      this.gridView,
      this.content,
      this.isSelector,
      this.storageSelected})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (content == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    if (content.isEmpty && storageSelected) {
      return Center(
        child: Text("Nothing found"),
      );
    }

    if (content.isEmpty && !storageSelected) {
      return Center(
        child: Text("Please select storage"),
      );
    }

    if (gridView) {
      return ProxmoxLayoutBuilder(builder: (context, layout) {
        final wide = layout != ProxmoxLayout.slim;
        return GridView.builder(
          itemCount: content.length,
          itemBuilder: (context, index) => GridTile(
            child: Card(
              child: InkWell(
                onTap: isSelector
                    ? () => Navigator.pop(context, content[index])
                    : null,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      getContentIcon(content[index].content),
                      color: Color.fromARGB(255, 152, 162, 201),
                    ),
                    FractionallySizedBox(
                      widthFactor: 0.8,
                      child: Text(
                        Renderers.renderStorageContent(content[index].volid),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(Renderers.formatSize(content[index].size))
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
      itemCount: content.length,
      itemBuilder: (context, index) => Card(
        child: ListTile(
          leading: Icon(
            getContentIcon(content[index].content),
            color: Color.fromARGB(255, 152, 162, 201),
          ),
          title: Text(
            Renderers.renderStorageContent(content[index].volid),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Text(Renderers.formatSize(content[index].size)),
          onTap:
              isSelector ? () => Navigator.pop(context, content[index]) : null,
        ),
      ),
    );
  }

  IconData getContentIcon(PveStorageContentType content) {
    switch (content) {
      case PveStorageContentType.iso:
        return FontAwesomeIcons.compactDisc;
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
