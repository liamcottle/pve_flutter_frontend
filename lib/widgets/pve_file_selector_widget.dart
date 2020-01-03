import 'package:flutter/material.dart';
import 'package:proxmox_dart_api_client/proxmox_dart_api_client.dart';
import 'package:pve_flutter_frontend/bloc/pve_file_selector_bloc.dart';
import 'package:pve_flutter_frontend/bloc/pve_storage_selector_bloc.dart';

import 'package:pve_flutter_frontend/utils/proxmox_layout_builder.dart';
import 'package:pve_flutter_frontend/utils/renderers.dart';
import 'package:pve_flutter_frontend/widgets/proxmox_capacity_indicator.dart';

class PveFileSelector extends StatefulWidget {
  final PveFileSelectorBloc fBloc;
  final PveStorageSelectorBloc sBloc;

  const PveFileSelector({Key key, this.fBloc, this.sBloc}) : super(key: key);
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
                  child: PveFileSelectorWidget(
                    fBloc: widget.fBloc,
                    sBloc: widget.sBloc,
                  ),
                ),
              )
            : PveFileSelectorWidget(fBloc: widget.fBloc, sBloc: widget.sBloc));
  }

  @override
  void dispose() {
    super.dispose();
    widget.fBloc.dispose();
    widget.sBloc.dispose();
  }
}

class PveFileSelectorWidget extends StatefulWidget {
  final PveFileSelectorBloc fBloc;
  final PveStorageSelectorBloc sBloc;

  const PveFileSelectorWidget({
    Key key,
    @required this.fBloc,
    @required this.sBloc,
  }) : super(key: key);

  @override
  _PveFileSelectorWidgetState createState() => _PveFileSelectorWidgetState();
}

class _PveFileSelectorWidgetState extends State<PveFileSelectorWidget> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.sBloc.state
        .where((state) =>
            (state?.value?.id != widget.fBloc.storageId) &&
            state?.value != null)
        .listen(
            (state) => widget.fBloc.events.add(ChangeStorage(state.value.id)));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color.fromARGB(255, 243, 246, 255),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Text(
              "Storage",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            Container(
              height: 200,
              child: StreamBuilder<PveStorageSelectorState>(
                  stream: widget.sBloc.state,
                  initialData: widget.sBloc.state.value,
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data.storages != null) {
                      final state = snapshot.data;
                      return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: state.storages.length,
                          itemBuilder: (context, index) {
                            var storage = state.storages[index];
                            var isSelected = storage.id == state.value.id;
                            var storageIcon =
                                getStorageIcon(storage.type, isSelected);
                            return Container(
                              width: 300,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Card(
                                  color: isSelected
                                      ? Color(0xff3e4bf5)
                                      : Colors.white,
                                  elevation: isSelected ? 4 : 1,
                                  child: InkWell(
                                      onTap: () {
                                        widget.sBloc.events
                                            .add(StorageSelectedEvent(storage));
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: storageIcon,
                                              ),
                                              Text(
                                                storage.id,
                                                style: TextStyle(
                                                    color: isSelected
                                                        ? Colors.white
                                                        : Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                "(${storage.content})",
                                                style: TextStyle(
                                                  color: isSelected
                                                      ? Colors.white54
                                                      : Colors.black54,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Expanded(
                                                child: Align(
                                                  alignment: FractionalOffset
                                                      .bottomCenter,
                                                  child:
                                                      ProxmoxCapacityIndicator(
                                                    usedValue:
                                                        Renderers.formatSize(
                                                            storage.usedSpace),
                                                    usedPercent:
                                                        storage.usedPercent,
                                                    totalValue:
                                                        Renderers.formatSize(
                                                            storage.totalSpace),
                                                    selected: isSelected,
                                                  ),
                                                ),
                                              ),
                                            ]),
                                      )),
                                ),
                              ),
                            );
                          });
                    }
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }),
            ),
            Expanded(
              child: StreamBuilder<PveFileSelectorState>(
                  stream: widget.fBloc.state,
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
                                        widget.fBloc.events.add(ToggleSearch()),
                                  ),
                                  IconButton(
                                    color: Color.fromARGB(255, 152, 162, 201),
                                    icon: Icon(
                                      state.gridView
                                          ? Icons.view_list
                                          : Icons.view_module,
                                    ),
                                    onPressed: () => widget.fBloc.events
                                        .add(ToggleGridListView()),
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
                                  onChanged: (searchTerm) => widget.fBloc.events
                                      .add(FilterContent(
                                          searchTerm: searchTerm)),
                                ),
                          Expanded(
                              child: FileSelectorContentView(
                            gridView: state.gridView,
                            content: state.content,
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

  Widget getStorageIcon(String storageType, bool selected) {
    var icon = Icons.cloud;
    if (storageType == "dir") {
      icon = Icons.folder;
    }

    if (storageType == "nfs") {
      icon = Icons.folder_shared;
    }
    return Container(
      height: 50,
      width: 50,
      child: Card(
        color: selected ? Colors.white : Color.fromARGB(255, 243, 246, 255),
        elevation: 0,
        child: Icon(icon),
      ),
    );
  }
}

class FileSelectorContentView extends StatelessWidget {
  final bool gridView;
  final List<PveNodesStorageContentModel> content;

  const FileSelectorContentView({Key key, this.gridView, this.content})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (content == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    if (content.isEmpty) {
      return Center(
        child: Text("Nothing found"),
      );
    }

    if (gridView) {
      return GridView.builder(
        itemCount: content.length,
        itemBuilder: (context, index) => GridTile(
          child: Card(
            child: InkWell(
              onTap: () => Navigator.pop(context, content[index]),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.sd_card,
                    size: 72,
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
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5),
      );
    }

    return ListView.builder(
      itemCount: content.length,
      itemBuilder: (context, index) => Card(
        child: ListTile(
          leading: Icon(
            Icons.sd_card,
            color: Color.fromARGB(255, 152, 162, 201),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                Renderers.renderStorageContent(content[index].volid),
              ),
              Text(Renderers.formatSize(content[index].size))
            ],
          ),
          onTap: () => Navigator.pop(context, content[index]),
        ),
      ),
    );
  }
}
