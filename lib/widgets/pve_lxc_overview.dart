import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:proxmox_dart_api_client/proxmox_dart_api_client.dart';
import 'package:pve_flutter_frontend/bloc/pve_file_selector_bloc.dart';
import 'package:pve_flutter_frontend/bloc/pve_lxc_overview_bloc.dart';
import 'package:pve_flutter_frontend/bloc/pve_migrate_bloc.dart';
import 'package:pve_flutter_frontend/bloc/pve_node_selector_bloc.dart';
import 'package:pve_flutter_frontend/bloc/pve_resource_bloc.dart';
import 'package:pve_flutter_frontend/bloc/pve_storage_selector_bloc.dart';
import 'package:pve_flutter_frontend/bloc/pve_task_log_bloc.dart';
import 'package:pve_flutter_frontend/bloc/pve_task_log_viewer_bloc.dart';
import 'package:pve_flutter_frontend/states/pve_file_selector_state.dart';
import 'package:pve_flutter_frontend/states/pve_lxc_overview_state.dart';
import 'package:pve_flutter_frontend/states/pve_migrate_state.dart';
import 'package:pve_flutter_frontend/states/pve_node_selector_state.dart';
import 'package:pve_flutter_frontend/states/pve_resource_state.dart';
import 'package:pve_flutter_frontend/states/pve_storage_selector_state.dart';
import 'package:pve_flutter_frontend/states/pve_task_log_state.dart';
import 'package:pve_flutter_frontend/states/pve_task_log_viewer_state.dart';
import 'package:pve_flutter_frontend/utils/utils.dart';
import 'package:pve_flutter_frontend/widgets/proxmox_stream_builder_widget.dart';
import 'package:pve_flutter_frontend/widgets/proxmox_stream_listener.dart';
import 'package:pve_flutter_frontend/widgets/pve_action_card_widget.dart';
import 'package:pve_flutter_frontend/widgets/pve_guest_backup_widget.dart';
import 'package:pve_flutter_frontend/widgets/pve_guest_migrate_widget.dart';
import 'package:pve_flutter_frontend/widgets/pve_guest_overview_header.dart';
import 'package:pve_flutter_frontend/widgets/pve_lxc_options_widget.dart';
import 'package:pve_flutter_frontend/widgets/pve_lxc_power_settings_widget.dart';
import 'package:pve_flutter_frontend/widgets/pve_resource_data_card_widget.dart';
import 'package:pve_flutter_frontend/widgets/pve_task_log_expansiontile_widget.dart';
import 'package:pve_flutter_frontend/widgets/pve_task_log_widget.dart';

class PveLxcOverview extends StatelessWidget {
  static final routeName = RegExp(r"\/nodes\/(\S+)\/lxc\/(\d+)");
  final String guestID;

  const PveLxcOverview({Key? key, required this.guestID}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final lxcBloc = Provider.of<PveLxcOverviewBloc>(context);
    final resourceBloc = Provider.of<PveResourceBloc>(context);
    final taskBloc = Provider.of<PveTaskLogBloc>(context);

    final width = MediaQuery.of(context).size.width;

    return StreamListener<PveResourceState>(
      stream: resourceBloc.state,
      onStateChange: (globalResourceState) {
        final guest = globalResourceState.resourceByID('lxc/$guestID');
        if (guest.node != lxcBloc.latestState.nodeID) {
          lxcBloc.events.add(Migration(false, guest.node));
        }
      },
      child: ProxmoxStreamBuilder<PveLxcOverviewBloc, PveLxcOverviewState>(
          bloc: lxcBloc,
          builder: (context, state) {
            final status = state.currentStatus;
            final config = state.config;
            return SafeArea(
              child: Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  title: Text(config?.hostname ?? 'CT $guestID'),
                ),
                backgroundColor: Theme.of(context).primaryColor,
                body: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      PveGuestOverviewHeader(
                        background: !(status?.template ?? false)
                            ? PveGuestHeaderRRDPageView(
                                rrdData: state.rrdData,
                              )
                            : Center(
                                child: Text(
                                  "TEMPLATE",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                        width: width,
                        guestID: guestID,
                        guestStatus: status?.getLxcStatus(),
                        guestName: config?.hostname ?? 'CT $guestID',
                        guestNodeID: state.nodeID,
                        guestType: 'lxc',
                        ha: status?.ha,
                        template: status?.template ?? false,
                      ),
                      ProxmoxStreamBuilder<PveTaskLogBloc, PveTaskLogState>(
                        bloc: taskBloc,
                        builder: (context, taskState) {
                          if (taskState.tasks != null &&
                              taskState.tasks.isNotEmpty) {
                            return PveTaskExpansionTile(
                              headerColor: Colors.white,
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
                              if (!(status?.template ?? false))
                                ActionCard(
                                  icon: Icon(
                                    Icons.power_settings_new,
                                    size: 55,
                                    color: Colors.white24,
                                  ),
                                  title: 'Power Settings',
                                  onTap: () => showPowerMenuBottomSheet(
                                      context, lxcBloc),
                                ),
                              if (!(status?.template ?? false))
                                ActionCard(
                                  icon: Icon(
                                    Icons.queue_play_next,
                                    size: 55,
                                    color: Colors.white24,
                                  ),
                                  title: 'Console',
                                  onTap: () => showConsoleMenuBottomSheet(
                                      context,
                                      lxcBloc.apiClient,
                                      guestID,
                                      state.nodeID,
                                      'lxc'),
                                ),
                              ActionCard(
                                icon: Icon(
                                  Icons.settings,
                                  size: 55,
                                  color: Colors.white24,
                                ),
                                title: 'Options',
                                onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) => PveLxcOptions(
                                            lxcBloc: lxcBloc,
                                          ),
                                      fullscreenDialog: true),
                                ),
                              ),
                              if (!resourceBloc.latestState.isStandalone)
                                ActionCard(
                                  icon: Icon(
                                    FontAwesomeIcons.paperPlane,
                                    size: 55,
                                    color: Colors.white24,
                                  ),
                                  title: 'Migrate',
                                  onTap: () => Navigator.of(context).push(
                                      _createMigrationRoute(
                                          guestID,
                                          state.nodeID,
                                          resourceBloc.apiClient!)),
                                ),
                              ActionCard(
                                icon: Icon(
                                  FontAwesomeIcons.save,
                                  size: 55,
                                  color: Colors.white24,
                                ),
                                title: 'Backup',
                                onTap: () => Navigator.of(context).push(
                                    _createBackupRoute(guestID, state.nodeID,
                                        resourceBloc.apiClient!)),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (config != null) ...[
                        PveResourceDataCardWidget(
                          title: Text(
                            'Resources',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          children: <Widget>[
                            ListTile(
                              leading: Icon(FontAwesomeIcons.memory),
                              title: Text('${config.memory}'),
                              subtitle: Text('Memory'),
                              dense: true,
                            ),
                            ListTile(
                              leading: Icon(Icons.cached),
                              title: Text('${config.swap}'),
                              subtitle: Text('Swap'),
                              dense: true,
                            ),
                            ListTile(
                              leading: Icon(Icons.memory),
                              title: Text('${config.cores ?? 'unlimited'}'),
                              subtitle: Text('Cores'),
                              dense: true,
                            ),
                            ListTile(
                              leading: Icon(FontAwesomeIcons.hdd),
                              dense: true,
                              title: Text('${config.rootfs}'),
                            ),
                          ],
                        ),
                        PveResourceDataCardWidget(
                            title: Text(
                              'Network',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            children: <Widget>[
                              for (var net in config.net!)
                                ListTile(
                                  leading: Icon(FontAwesomeIcons.ethernet),
                                  dense: true,
                                  title: Text('$net'),
                                ),
                            ]),
                        PveResourceDataCardWidget(
                            title: Text(
                              'DNS',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            children: <Widget>[
                              ListTile(
                                leading: Icon(FontAwesomeIcons.globe),
                                dense: true,
                                title: Text(
                                    config.searchdomain ?? 'Use host settings'),
                                subtitle: Text('DNS Domain'),
                              ),
                              ListTile(
                                leading: Icon(FontAwesomeIcons.search),
                                dense: true,
                                title: Text(
                                    config.nameserver ?? 'Use host settings'),
                                subtitle: Text('DNS Server'),
                              ),
                            ]),
                      ]
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }

  Route _createMigrationRoute(
    String guestID,
    String nodeID,
    ProxmoxApiClient client,
  ) {
    return MaterialPageRoute(
      builder: (context) => MultiProvider(providers: [
        Provider<PveMigrateBloc>(
          create: (context) => PveMigrateBloc(
              guestID: guestID,
              apiClient: client,
              init: PveMigrateState.init(nodeID, 'lxc'))
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
    );
  }

  Route _createBackupRoute(
    String guestID,
    String nodeID,
    ProxmoxApiClient client,
  ) {
    return MaterialPageRoute(
      builder: (context) => MultiProvider(
          providers: [
            Provider(
              create: (context) => PveStorageSelectorBloc(
                apiClient: client,
                init: PveStorageSelectorState.init(nodeID: nodeID)
                    .rebuild((b) => b..content = PveStorageContentType.backup),
              )..events.add(LoadStoragesEvent()),
              dispose: (context, PveStorageSelectorBloc bloc) => bloc.dispose(),
            ),
            Provider(
              create: (context) => PveFileSelectorBloc(
                apiClient: client,
                init: PveFileSelectorState.init(nodeID: nodeID).rebuild((b) => b
                  ..guestID = int.parse(guestID)
                  ..fileType = PveStorageContentType.backup),
              )..events.add(LoadStorageContent()),
              dispose: (context, PveFileSelectorBloc bloc) => bloc.dispose(),
            )
          ],
          child: PveGuestBackupWidget(
            guestID: guestID,
          )),
    );
  }

  Future<T?> showPowerMenuBottomSheet<T>(
      BuildContext context, PveLxcOverviewBloc lxcBloc) async {
    return showModalBottomSheet(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
      context: context,
      builder: (context) => PveLxcPowerSettings(
        lxcBloc: lxcBloc,
      ),
    );
  }
}
