import 'dart:math';

import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:pve_flutter_frontend/bloc/pve_migrate_bloc.dart';
import 'package:pve_flutter_frontend/bloc/pve_node_selector_bloc.dart';
import 'package:pve_flutter_frontend/bloc/pve_qemu_overview_bloc.dart';
import 'package:pve_flutter_frontend/bloc/pve_resource_bloc.dart';
import 'package:pve_flutter_frontend/bloc/pve_task_log_bloc.dart';
import 'package:pve_flutter_frontend/bloc/pve_task_log_viewer_bloc.dart';
import 'package:proxmox_dart_api_client/proxmox_dart_api_client.dart';
import 'package:pve_flutter_frontend/states/pve_migrate_state.dart';
import 'package:pve_flutter_frontend/states/pve_node_selector_state.dart';
import 'package:pve_flutter_frontend/states/pve_qemu_overview_state.dart';
import 'package:pve_flutter_frontend/states/pve_resource_state.dart';
import 'package:pve_flutter_frontend/states/pve_task_log_state.dart';
import 'package:pve_flutter_frontend/states/pve_task_log_viewer_state.dart';
import 'package:pve_flutter_frontend/utils/renderers.dart';
import 'package:pve_flutter_frontend/widgets/proxmox_stream_builder_widget.dart';
import 'package:pve_flutter_frontend/widgets/proxmox_stream_listener.dart';
import 'package:pve_flutter_frontend/widgets/pve_action_card_widget.dart';
import 'package:pve_flutter_frontend/widgets/pve_guest_overview_header.dart';
import 'package:pve_flutter_frontend/widgets/pve_guest_migrate_widget.dart';
import 'package:pve_flutter_frontend/widgets/pve_node_overview.dart';
import 'package:pve_flutter_frontend/widgets/pve_qemu_options_widget.dart';
import 'package:pve_flutter_frontend/widgets/pve_qemu_power_settings_widget.dart';
import 'package:pve_flutter_frontend/widgets/pve_resource_data_card_widget.dart';
import 'package:pve_flutter_frontend/widgets/pve_resource_status_chip_widget.dart';
import 'package:pve_flutter_frontend/widgets/pve_task_log_expansiontile_widget.dart';
import 'package:pve_flutter_frontend/widgets/pve_task_log_widget.dart';

class PveQemuOverview extends StatelessWidget {
  static final routeName = RegExp(r"\/nodes\/(\S+)\/qemu\/(\d+)");
  final String guestID;

  const PveQemuOverview({Key key, this.guestID}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<PveQemuOverviewBloc>(context);
    final rBloc = Provider.of<PveResourceBloc>(context);
    final taskBloc = Provider.of<PveTaskLogBloc>(context);
    final width = MediaQuery.of(context).size.width;
    return StreamListener<PveResourceState>(
      stream: rBloc.state,
      onStateChange: (globalResourceState) {
        final guest = globalResourceState.resourceByID('qemu/$guestID');
        if (guest.node != bloc.latestState.nodeID) {
          bloc.events.add(Migration(false, guest.node));
        }
      },
      child: ProxmoxStreamBuilder<PveQemuOverviewBloc, PveQemuOverviewState>(
          bloc: bloc,
          builder: (context, state) {
            final status = state.currentStatus;
            final config = state.config;
            final rrdData = state.rrdData;

            return SafeArea(
              child: Scaffold(
                  appBar: AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    title: Text(config?.name ?? 'VM $guestID'),
                  ),
                  backgroundColor: Theme.of(context).primaryColor,
                  body: SingleChildScrollView(
                      child: Column(
                    children: <Widget>[
                      PveGuestOverviewHeader(
                        background: _buildRRDDiagrams(rrdData),
                        width: width,
                        guestID: guestID,
                        guestStatus: status?.getQemuStatus(),
                        guestName: config?.name ?? 'VM $guestID',
                        guestNodeID: state.nodeID,
                        guestType: 'qemu',
                      ),
                      ProxmoxStreamBuilder<PveTaskLogBloc, PveTaskLogState>(
                        bloc: taskBloc,
                        builder: (context, taskState) {
                          if (taskState.tasks != null &&
                              taskState.tasks.isNotEmpty) {
                            return PveTaskExpansionTile(
                              task: taskState.tasks.first,
                              showMorePage: Provider<PveTaskLogBloc>(
                                create: (context) => PveTaskLogBloc(
                                  apiClient: taskBloc.apiClient,
                                  init: PveTaskLogState.init(state.nodeID),
                                )
                                  ..events.add(
                                    FilterTasksByGuestID(
                                      guestID: guestID,
                                    ),
                                  )
                                  ..events.add(LoadTasks()),
                                dispose: (context, bloc) => bloc.dispose(),
                                child: PveTaskLog(),
                              ),
                            );
                          }
                          return Container();
                        },
                      ),
                      Container(
                        height: 130,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              ActionCard(
                                icon: Icon(
                                  Icons.power_settings_new,
                                  size: 55,
                                  color: Colors.white24,
                                ),
                                title: 'Power Settings',
                                onTap: () => Navigator.of(context)
                                    .push(_createShutdownRoute(bloc)),
                              ),
                              ActionCard(
                                icon: Icon(
                                  Icons.settings,
                                  size: 55,
                                  color: Colors.white24,
                                ),
                                title: 'Options',
                                onTap: () => Navigator.of(context)
                                    .push(_createOptionsRoute(bloc)),
                              ),
                              if (!rBloc.latestState.isStandalone)
                                ActionCard(
                                  icon: Icon(
                                    FontAwesomeIcons.paperPlane,
                                    size: 55,
                                    color: Colors.white24,
                                  ),
                                  title: 'Migrate',
                                  onTap: () => Navigator.of(context).push(
                                      _createMigrationRoute(guestID,
                                          state.nodeID, bloc.apiClient)),
                                ),
                              ActionCard(
                                icon: Icon(
                                  FontAwesomeIcons.save,
                                  size: 55,
                                  color: Colors.white24,
                                ),
                                title: 'Backup',
                                onTap: null,
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (config != null)
                        PveResourceDataCardWidget(
                            expandable: false,
                            title: Text(
                              'Hardware',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            children: [
                              ListTile(
                                leading: Icon(FontAwesomeIcons.memory),
                                title: Text('${config.memory}'),
                                dense: true,
                              ),
                              ListTile(
                                leading: Icon(Icons.memory),
                                title: Text(
                                    '${config.cores} Cores ${config.sockets} Socket'),
                                dense: true,
                              ),
                              ListTile(
                                leading: Icon(FontAwesomeIcons.microchip),
                                title: Text(
                                    config.bios?.name ?? 'Default (SeaBIOS)'),
                                dense: true,
                              ),
                              ListTile(
                                leading: Icon(FontAwesomeIcons.cogs),
                                dense: true,
                                title:
                                    Text(config.machine ?? 'Default (i440fx)'),
                              ),
                              ListTile(
                                leading: Icon(FontAwesomeIcons.cogs),
                                title: Text(
                                    config.scsihw?.name ?? 'Default (i440fx)'),
                                dense: true,
                              ),
                              ListTile(
                                leading: Icon(FontAwesomeIcons.hdd),
                                title: Text(config.scsi0),
                                dense: true,
                              ),
                              ListTile(
                                leading: Icon(FontAwesomeIcons.ethernet),
                                dense: true,
                                title: Text(config.net0),
                              )
                            ]),
                    ],
                  ))),
            );
          }),
    );
  }

  Route _createShutdownRoute(PveQemuOverviewBloc bloc) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => Provider.value(
        value: bloc,
        child: PveQemuPowerSettings(),
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.fastOutSlowIn,
            ),
          ),
          child: child,
        );
      },
    );
  }

  Route _createOptionsRoute(PveQemuOverviewBloc bloc) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => Provider.value(
        value: bloc,
        child: PveQemuOptions(),
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.fastOutSlowIn,
            ),
          ),
          child: child,
        );
      },
    );
  }

  Route _createMigrationRoute(
    String guestID,
    String nodeID,
    ProxmoxApiClient client,
  ) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          MultiProvider(providers: [
        Provider<PveMigrateBloc>(
          create: (context) => PveMigrateBloc(
              guestID: guestID,
              apiClient: client,
              init: PveMigrateState.init(nodeID, 'qemu'))
            ..events.add(CheckMigratePreconditions()),
          dispose: (context, bloc) => bloc.dispose(),
        ),
        Provider(
          create: (context) => PveNodeSelectorBloc(
            apiClient: client,
            init: PveNodeSelectorState.init(onlineValidator: true)
                .rebuild((b) => b..disallowedNodes.replace([nodeID])),
          )..events.add(LoadNodesEvent()),
          dispose: (context, PveNodeSelectorBloc bloc) => bloc.dispose(),
        ),
        Provider(
          create: (context) => PveTaskLogViewerBloc(
            apiClient: client,
            init: PveTaskLogViewerState.init(
              nodeID,
            ),
          ),
          dispose: (context, PveTaskLogViewerBloc bloc) => bloc.dispose(),
        )
      ], child: PveGuestMigrate()),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.fastOutSlowIn,
            ),
          ),
          child: child,
        );
      },
    );
  }

  Widget _buildRRDDiagrams(BuiltList<PveGuestRRDdataModel> rrdData) {
    if (rrdData != null && rrdData.isNotEmpty) {
      return PageView.builder(
          itemCount: 2,
          itemBuilder: (context, item) {
            if (item == 0) {
              return PveRRDChart(
                titlePadding: EdgeInsets.only(bottom: 80),
                titleWidth: 150,
                titleAlginment: CrossAxisAlignment.end,
                title: 'CPU (${rrdData.last.maxcpu ?? '-'})',
                subtitle:
                    (rrdData.last?.cpu ?? 0 * 100).toStringAsFixed(2) + "%",
                data: rrdData
                    .map((e) => Point(e.time.millisecondsSinceEpoch, e.cpu)),
                icon: Icon(Icons.memory),
              );
            }
            if (item == 1) {
              return PveRRDChart(
                titlePadding: EdgeInsets.only(bottom: 80),
                titleWidth: 200,
                titleAlginment: CrossAxisAlignment.end,
                title: 'Memory',
                subtitle: Renderers.formatSize(rrdData.last.mem ?? 0.0),
                data: rrdData
                    .map((e) => Point(e.time.millisecondsSinceEpoch, e.mem)),
                icon: Icon(Icons.timer),
              );
            }
          });
    }
    return Container(
      height: 200,
      child: Center(
        child: Text('no rrd data'),
      ),
    );
  }
}
