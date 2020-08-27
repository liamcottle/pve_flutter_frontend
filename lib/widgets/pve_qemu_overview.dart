import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:pve_flutter_frontend/bloc/pve_file_selector_bloc.dart';
import 'package:pve_flutter_frontend/bloc/pve_migrate_bloc.dart';
import 'package:pve_flutter_frontend/bloc/pve_node_selector_bloc.dart';
import 'package:pve_flutter_frontend/bloc/pve_qemu_overview_bloc.dart';
import 'package:pve_flutter_frontend/bloc/pve_resource_bloc.dart';
import 'package:pve_flutter_frontend/bloc/pve_storage_selector_bloc.dart';
import 'package:pve_flutter_frontend/bloc/pve_task_log_bloc.dart';
import 'package:pve_flutter_frontend/bloc/pve_task_log_viewer_bloc.dart';
import 'package:proxmox_dart_api_client/proxmox_dart_api_client.dart';
import 'package:pve_flutter_frontend/states/pve_file_selector_state.dart';
import 'package:pve_flutter_frontend/states/pve_migrate_state.dart';
import 'package:pve_flutter_frontend/states/pve_node_selector_state.dart';
import 'package:pve_flutter_frontend/states/pve_qemu_overview_state.dart';
import 'package:pve_flutter_frontend/states/pve_resource_state.dart';
import 'package:pve_flutter_frontend/states/pve_storage_selector_state.dart';
import 'package:pve_flutter_frontend/states/pve_task_log_state.dart';
import 'package:pve_flutter_frontend/states/pve_task_log_viewer_state.dart';
import 'package:pve_flutter_frontend/widgets/proxmox_stream_builder_widget.dart';
import 'package:pve_flutter_frontend/widgets/proxmox_stream_listener.dart';
import 'package:pve_flutter_frontend/widgets/pve_action_card_widget.dart';
import 'package:pve_flutter_frontend/widgets/pve_guest_backup_widget.dart';
import 'package:pve_flutter_frontend/widgets/pve_guest_overview_header.dart';
import 'package:pve_flutter_frontend/widgets/pve_guest_migrate_widget.dart';
import 'package:pve_flutter_frontend/widgets/pve_qemu_options_widget.dart';
import 'package:pve_flutter_frontend/widgets/pve_qemu_power_settings_widget.dart';
import 'package:pve_flutter_frontend/widgets/pve_resource_data_card_widget.dart';
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
                        background: PveGuestHeaderRRDPageView(
                          rrdData: rrdData,
                        ),
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
                              ActionCard(
                                icon: Icon(
                                  Icons.power_settings_new,
                                  size: 55,
                                  color: Colors.white24,
                                ),
                                title: 'Power Settings',
                                onTap: () =>
                                    showPowerMenuBottomSheet(context, bloc),
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
                                onTap: () => Navigator.of(context).push(
                                    _createBackupRoute(
                                        guestID, state.nodeID, bloc.apiClient)),
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
                                subtitle: Text('Memory'),
                                dense: true,
                              ),
                              ListTile(
                                leading: Icon(Icons.memory),
                                title: Text(
                                    '${config.cores} Cores ${config.sockets} Socket'),
                                subtitle: Text('Processor'),
                                dense: true,
                              ),
                              ListTile(
                                leading: Icon(FontAwesomeIcons.microchip),
                                title: Text(
                                    config.bios?.name ?? 'Default (SeaBIOS)'),
                                subtitle: Text('BIOS'),
                                dense: true,
                              ),
                              ListTile(
                                leading: Icon(FontAwesomeIcons.cogs),
                                dense: true,
                                title:
                                    Text(config.machine ?? 'Default (i440fx)'),
                                subtitle: Text('Machine Type'),
                              ),
                              ListTile(
                                leading: Icon(FontAwesomeIcons.database),
                                title: Text(
                                    config.scsihw?.name ?? 'Default (i440fx)'),
                                subtitle: Text('SCSI Controller'),
                                dense: true,
                              ),
                              for (var ide in config.ide)
                                ListTile(
                                  leading: Icon(FontAwesomeIcons.compactDisc),
                                  title: Text(ide),
                                  subtitle: Text('CD/DVD Drive'),
                                  dense: true,
                                ),
                              for (var scsi in config.scsi)
                                ListTile(
                                  leading: Icon(FontAwesomeIcons.hdd),
                                  title: Text(scsi),
                                  subtitle: Text('Hard Disk'),
                                  dense: true,
                                ),
                              for (var net in config.net)
                                ListTile(
                                  leading: Icon(FontAwesomeIcons.ethernet),
                                  dense: true,
                                  subtitle: Text('Network Device'),
                                  title: Text(net),
                                )
                            ]),
                    ],
                  ))),
            );
          }),
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
                    .rebuild((b) => b
                      ..content = PveStorageContentType.backup
                      ..filterActive = true),
              )..events.add(LoadStoragesEvent()),
              dispose: (context, PveStorageSelectorBloc bloc) => bloc.dispose(),
            ),
            Provider(
              create: (context) => PveFileSelectorBloc(
                apiClient: client,
                init: PveFileSelectorState.init(nodeID: nodeID).rebuild((b) => b
                  ..volidFilter = 'qemu-$guestID-'
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

  Future<T> showPowerMenuBottomSheet<T>(
      BuildContext context, PveQemuOverviewBloc qemuBloc) async {
    return showModalBottomSheet(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
      context: context,
      builder: (context) => Provider.value(
        value: qemuBloc,
        child: PveQemuPowerSettings(),
      ),
    );
  }
}
