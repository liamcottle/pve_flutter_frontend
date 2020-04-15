import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:proxmox_dart_api_client/proxmox_dart_api_client.dart';
import 'package:pve_flutter_frontend/bloc/pve_authentication_bloc.dart';
import 'package:pve_flutter_frontend/bloc/pve_cluster_status_bloc.dart';
import 'package:pve_flutter_frontend/bloc/pve_file_selector_bloc.dart';
import 'package:pve_flutter_frontend/bloc/pve_resource_bloc.dart';
import 'package:pve_flutter_frontend/bloc/pve_storage_selector_bloc.dart';
import 'package:pve_flutter_frontend/states/pve_cluster_status_state.dart';
import 'package:pve_flutter_frontend/states/pve_file_selector_state.dart';
import 'package:pve_flutter_frontend/states/pve_resource_state.dart';
import 'package:pve_flutter_frontend/states/pve_storage_selector_state.dart';
import 'package:pve_flutter_frontend/utils/renderers.dart';
import 'package:pve_flutter_frontend/widgets/cluster_status_widget.dart';
import 'package:pve_flutter_frontend/widgets/proxmox_capacity_indicator.dart';
import 'package:pve_flutter_frontend/widgets/proxmox_stream_builder_widget.dart';
import 'package:pve_flutter_frontend/widgets/pve_file_selector_widget.dart';
import 'package:pve_flutter_frontend/widgets/pve_help_icon_button_widget.dart';
import 'package:pve_flutter_frontend/widgets/pve_resource_status_chip_widget.dart';
import 'package:rxdart/rxdart.dart';

import 'main_layout_wide.dart';

class MainLayoutSlim extends StatefulWidget {
  @override
  _MainLayoutSlimState createState() => _MainLayoutSlimState();
}

class _MainLayoutSlimState extends State<MainLayoutSlim> {
  BehaviorSubject<int> pageSelector = BehaviorSubject.seeded(0);
  @override
  Widget build(BuildContext context) {
    final apiClient = Provider.of<ProxmoxApiClient>(context);
    return Provider.value(
      value: pageSelector,
      child: StreamBuilder<int>(
        stream: pageSelector.stream,
        initialData: pageSelector.value,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            switch (snapshot.data) {
              case 0:
                return MobileDashboard();
                break;
              case 1:
                return Provider(
                    create: (context) => PveResourceBloc(
                          apiClient: apiClient,
                          init: PveResourceState.init().rebuild(
                            (b) => b
                              ..typeFilter.replace({'qemu', 'lxc', 'storage'}),
                          ),
                        )..events.add(PollResources()),
                    child: MobileResourceOverview());
                break;
              default:
            }
          }
          return Container();
        },
      ),
    );
  }

  @override
  dispose() {
    pageSelector.close();
    super.dispose();
  }
}

class PveMobileBottomNavigationbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final pageSelector = Provider.of<BehaviorSubject<int>>(context);
    return BottomNavigationBar(
        backgroundColor: Colors.white,
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.dashboard,
              ),
              title: Text("Dashboard")),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.developer_board,
              ),
              title: Text("Resources")),
        ],
        currentIndex: pageSelector.value,
        onTap: (index) => pageSelector.add(index));
  }
}

class MobileDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cBloc = Provider.of<PveClusterStatusBloc>(context);
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar(
            stretch: true,
            onStretchTrigger: () {
              // Function callback for stretch
              return;
            },
            expandedHeight: 300.0,
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: <StretchMode>[
                StretchMode.zoomBackground,
                StretchMode.blurBackground,
                StretchMode.fadeTitle,
              ],
              centerTitle: false,
              title: Text("Proxmox"),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment(0.0, 0.5),
                        end: Alignment(0.0, 0.0),
                        colors: <Color>[
                          Color(0x60000000),
                          Color(0x00000000),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              PveHelpIconButton(docPath: 'index.html'),
              IconButton(
                icon: Icon(Icons.input),
                tooltip: "Logout",
                onPressed: () => Provider.of<PveAuthenticationBloc>(context)
                    .events
                    .add(LoggedOut()),
              )
            ],
          ),
          ProxmoxStreamBuilder<PveClusterStatusBloc, PveClusterStatusState>(
              bloc: cBloc,
              builder: (context, cState) {
                return SliverPadding(
                  padding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 0),
                  sliver: SliverList(
                      delegate: SliverChildListDelegate([
                    Text(
                      "Status",
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    Text(cState.cluster?.name ?? "unkown"),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20.0, 0, 20),
                      child: ClusterStatus(
                        isHealthy: cState.healthy,
                        healthyColor: Colors.greenAccent,
                        warningColor: Colors.orangeAccent,
                        backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        version: cState.cluster?.version?.toString(),
                      ),
                    ),
                    Text(
                      "Nodes",
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    Divider(),
                    ...cState.nodes.map((node) {
                      return Card(
                        child: PveNodeListTile(
                          name: node.name,
                          online: node.online,
                          type: node.type,
                          level: node.level,
                          ip: node.ip,
                        ),
                      );
                    })
                  ])),
                );
                // return SliverList(
                //   delegate: SliverChildListDelegate([
                //     Center(child: CircularProgressIndicator()),
                //   ]),
                // );
              }),
        ],
      ),
      bottomNavigationBar: PveMobileBottomNavigationbar(),
    );
  }
}

class PveNodeListTile extends StatelessWidget {
  final String name;
  final bool online;
  final String type;
  final String level;
  final String ip;
  const PveNodeListTile(
      {Key key,
      @required this.name,
      @required this.online,
      @required this.type,
      this.level,
      this.ip = ''})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        Renderers.getDefaultResourceIcon(type),
      ),
      title: Text(name ?? "unkown"),
      subtitle: Text(getNodeTileSubtitle(online, level, ip)),
      trailing: Icon(Icons.power, color: online ? Colors.green : Colors.grey),
      onTap: () => Navigator.pushNamed(context, '/nodes/$name'),
    );
  }

  String getNodeTileSubtitle(bool online, String level, String ip) {
    if (online) {
      if (level != null && level.isNotEmpty) {
        return '$ip - $level';
      }
      return '$ip - no support';
    }
    return 'offline';
  }
}

class MobileResourceOverview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final rBloc = Provider.of<PveResourceBloc>(context);
    return ProxmoxStreamBuilder<PveResourceBloc, PveResourceState>(
      bloc: rBloc,
      builder: (context, rstate) {
        final client = Provider.of<ProxmoxApiClient>(context);
        final fResources = rstate.filterResources.toList();
        return Scaffold(
          endDrawer: _MobileResourceFilterSheet(),
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: AppbarSearchTextField(
              onChanged: (filter) => rBloc.events.add(FilterByName(filter)),
            ),
            actions: <Widget>[AppBarFilterIconButton()],
          ),
          body: ListView.separated(
            itemCount: fResources.length,
            separatorBuilder: (context, index) => Divider(),
            itemBuilder: (context, index) {
              final resource = fResources[index];

              if (const ['lxc', 'qemu'].contains(resource.type)) {
                return ListTile(
                  leading: Icon(
                    Renderers.getDefaultResourceIcon(resource.type,
                        shared: resource.shared),
                  ),
                  title: Text(resource.displayName),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(resource.node),
                      StatusChip(
                        status: resource.getStatus(),
                        fontzsize: 12,
                      ),
                    ],
                  ),
                  onTap: () {
                    if (['qemu', 'lxc'].contains(resource.type)) {
                      Navigator.pushNamed(
                          context, '/nodes/${resource.node}/${resource.id}');
                    }
                  },
                );
              }
              if (resource.type == 'node') {
                return PveNodeListTile(
                  name: resource.node,
                  online: resource.getStatus() == PveResourceStatusType.running,
                  type: resource.type,
                  level: resource.level,
                );
              }
              return ListTile(
                title: Text(resource.displayName),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(resource.node),
                    ProxmoxCapacityIndicator(
                      usedValue: Renderers.formatSize(resource.disk ?? 0),
                      totalValue: Renderers.formatSize(resource.maxdisk ?? 0),
                      usedPercent:
                          (resource.disk ?? 0.0) / (resource.maxdisk ?? 100.0),
                      icon: Icon(
                        Renderers.getDefaultResourceIcon(resource.type,
                            shared: resource.shared),
                      ),
                    ),
                  ],
                ),
                onTap: resource.getStatus() == PveResourceStatusType.running
                    ? () => showDialog(
                          context: context,
                          builder: (context) => PveFileSelector(
                            fBloc: PveFileSelectorBloc(
                                apiClient: client,
                                init: PveFileSelectorState.init(
                                        nodeID: resource.node)
                                    .rebuild((b) =>
                                        b..storageID = resource.storage)),
                            sBloc: PveStorageSelectorBloc(
                              apiClient: client,
                              init: PveStorageSelectorState.init(
                                      nodeID: resource.node)
                                  .rebuild(
                                      (b) => b..storage = resource.storage),
                            )..events.add(LoadStoragesEvent()),
                          ),
                        )
                    : null,
              );
            },
          ),
          bottomNavigationBar: PveMobileBottomNavigationbar(),
        );
      },
    );
  }
}

class AppbarSearchTextField extends StatefulWidget {
  final ValueChanged<String> onChanged;

  const AppbarSearchTextField({Key key, this.onChanged}) : super(key: key);
  @override
  _AppbarSearchTextFieldState createState() => _AppbarSearchTextFieldState();
}

class _AppbarSearchTextFieldState extends State<AppbarSearchTextField> {
  TextEditingController _controller;

  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.search,
            size: 20,
          ),
          contentPadding: EdgeInsets.fromLTRB(20, 5, 8, 5),
          prefixIconConstraints: BoxConstraints(minHeight: 32, minWidth: 32),
          fillColor: Color(0xFFF1F2F4),
          filled: true,
          isDense: true,
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.white))),
      style: TextStyle(fontSize: 20),
      onChanged: (value) => widget.onChanged(value),
      controller: _controller,
    );
  }
}

class _MobileResourceFilterSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final rBloc = Provider.of<PveResourceBloc>(context);

    return ProxmoxStreamBuilder<PveResourceBloc, PveResourceState>(
      bloc: rBloc,
      builder: (context, state) => Drawer(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Resources',
                  style: Theme.of(context).textTheme.headline5,
                ),
                CheckboxListTile(
                  dense: true,
                  title: Text('Nodes'),
                  value: state.typeFilter.contains('node'),
                  onChanged: (v) => rBloc.events.add(
                      FilterByType(addOrRemove(v, 'node', state.typeFilter))),
                ),
                CheckboxListTile(
                  dense: true,
                  title: Text('Qemu'),
                  value: state.typeFilter.contains('qemu'),
                  onChanged: (v) => rBloc.events.add(
                      FilterByType(addOrRemove(v, 'qemu', state.typeFilter))),
                ),
                CheckboxListTile(
                  dense: true,
                  title: Text('LXC'),
                  value: state.typeFilter.contains('lxc'),
                  onChanged: (v) => rBloc.events.add(
                      FilterByType(addOrRemove(v, 'lxc', state.typeFilter))),
                ),
                CheckboxListTile(
                  dense: true,
                  title: Text('Storage'),
                  value: state.typeFilter.contains('storage'),
                  onChanged: (v) => rBloc.events.add(FilterByType(
                      addOrRemove(v, 'storage', state.typeFilter))),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BuiltSet<String> addOrRemove(
      bool value, String element, BuiltSet<String> filter) {
    if (value) {
      return filter.rebuild((b) => b..add(element));
    } else {
      return filter.rebuild((b) => b..remove(element));
    }
  }
}

class AppBarFilterIconButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: Icon(
          FontAwesomeIcons.filter,
          color: Colors.black,
        ),
        onPressed: () => Scaffold.of(context).openEndDrawer());
  }
}
