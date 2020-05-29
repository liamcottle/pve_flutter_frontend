import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pve_flutter_frontend/bloc/pve_authentication_bloc.dart';
import 'package:pve_flutter_frontend/bloc/pve_cluster_status_bloc.dart';
import 'package:pve_flutter_frontend/bloc/pve_login_bloc.dart';
import 'package:pve_flutter_frontend/bloc/pve_lxc_overview_bloc.dart';
import 'package:pve_flutter_frontend/bloc/pve_node_overview_bloc.dart';
import 'package:pve_flutter_frontend/bloc/pve_qemu_overview_bloc.dart';
import 'package:pve_flutter_frontend/bloc/pve_resource_bloc.dart';
import 'package:pve_flutter_frontend/bloc/pve_task_log_bloc.dart';
import 'package:pve_flutter_frontend/events/pve_login_events.dart';
import 'package:pve_flutter_frontend/pages/404_page.dart';
import 'package:pve_flutter_frontend/pages/login_page.dart';
import 'package:pve_flutter_frontend/pages/main_layout_slim.dart';
import 'package:pve_flutter_frontend/pages/main_layout_wide.dart';
import 'package:pve_flutter_frontend/states/pve_cluster_status_state.dart';
import 'package:pve_flutter_frontend/states/pve_login_state.dart';
import 'package:pve_flutter_frontend/states/pve_lxc_overview_state.dart';
import 'package:pve_flutter_frontend/states/pve_node_overview_state.dart';
import 'package:pve_flutter_frontend/states/pve_qemu_overview_state.dart';
import 'package:pve_flutter_frontend/states/pve_resource_state.dart';
import 'package:pve_flutter_frontend/states/pve_task_log_state.dart';
import 'package:pve_flutter_frontend/widgets/proxmox_stream_listener.dart';
import 'package:pve_flutter_frontend/widgets/pve_create_vm_wizard_page.dart';
import 'package:proxmox_dart_api_client/proxmox_dart_api_client.dart'
    as proxclient;

import 'package:pve_flutter_frontend/utils/proxmox_layout_builder.dart';
import 'package:pve_flutter_frontend/widgets/pve_console_widget.dart';

import 'package:pve_flutter_frontend/bloc/proxmox_global_error_bloc.dart';
import 'package:pve_flutter_frontend/widgets/pve_lxc_overview.dart';
import 'package:pve_flutter_frontend/widgets/pve_node_overview.dart';
import 'package:pve_flutter_frontend/widgets/pve_qemu_overview.dart';
import 'package:pve_flutter_frontend/widgets/pve_splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final authBloc = PveAuthenticationBloc();
  try {
    var credentials = await proxclient.Credentials.fromPlatformStorage();
    var apiClient = proxclient.ProxmoxApiClient(credentials);
    await apiClient.refreshCredentials();
    authBloc.events.add(LoggedIn(apiClient));
  } catch (e) {
    print(e);
    authBloc.events.add(LoggedOut());
  }

  ProxmoxGlobalErrorBloc();
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
    if (kReleaseMode) ProxmoxGlobalErrorBloc().addError(details.exception);
  };
  Provider.debugCheckInvalidValueType = null;

  runApp(
    MultiProvider(
      providers: [
        Provider.value(value: authBloc),
        Provider<PveResourceBloc>(
          create: (context) => PveResourceBloc(init: PveResourceState.init()),
          dispose: (context, bloc) => bloc.dispose(),
        ),
      ],
      child: MyApp(
        authbloc: authBloc,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final PveAuthenticationBloc authbloc;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  MyApp({Key key, this.authbloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamListener(
      stream: authbloc.state,
      onStateChange: (state) {
        if (state is Authenticated) {
          Provider.of<PveResourceBloc>(context)
            ..apiClient = state.apiClient
            ..events.add(PollResources());
        }
        if (state is Unauthenticated) {
          Provider.of<PveResourceBloc>(context)..apiClient = null;
        }
      },
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: 'Proxmox',
        theme: ThemeData(
          brightness: Brightness.light,
          fontFamily: "Open Sans",
          primarySwatch: Colors.blue,
          primaryColor: Color(0xFF00617F),
          primaryTextTheme: TextTheme(
            headline6:
                TextStyle(fontFamily: "Open Sans", fontWeight: FontWeight.w700),
          ),
          scaffoldBackgroundColor: Color(0xFFf6f7f9),
        ),
        builder: (context, child) {
          return StreamListener(
            stream: ProxmoxGlobalErrorBloc().onError.distinct(),
            onStateChange: (error) async {
              if (!ProxmoxGlobalErrorBloc().dialogVisible) {
                ProxmoxGlobalErrorBloc().dialogVisible = true;

                await showDialog<String>(
                  context: navigatorKey.currentState.overlay.context,
                  builder: (BuildContext context) {
                    return StreamBuilder<Object>(
                        stream: ProxmoxGlobalErrorBloc().onError,
                        initialData: error,
                        builder: (context, snapshot) {
                          return AlertDialog(
                            contentPadding: const EdgeInsets.fromLTRB(
                                24.0, 12.0, 24.0, 16.0),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text('Error'),
                                Icon(Icons.warning),
                              ],
                            ),
                            content: SingleChildScrollView(
                              child: Text(snapshot.data?.toString() ?? ''),
                            ),
                          );
                        });
                  },
                );
                ProxmoxGlobalErrorBloc().dialogVisible = false;
              }
            },
            child: child,
          );
        },
        onGenerateRoute: (context) {
          if (authbloc.state.value is Uninitialized) {
            return MaterialPageRoute(
              builder: (context) => PveSplashScreen(),
            );
          }

          if (authbloc.state.value is Unauthenticated ||
              context.name == '/login') {
            return MaterialPageRoute(
              builder: (context) {
                return MultiProvider(
                  providers: [
                    Provider<PveLoginBloc>(
                      create: (context) =>
                          PveLoginBloc(init: PveLoginState.init(''))
                            ..events.add(LoadOrigin()),
                      dispose: (context, bloc) => bloc.dispose(),
                    ),
                    Provider.value(
                      value: authbloc,
                    )
                  ],
                  child: PveLoginPage(),
                );
              },
            );
          }
          if (authbloc.state.value is Authenticated) {
            final state = authbloc.state.value as Authenticated;
            if (PveQemuOverview.routeName.hasMatch(context.name)) {
              final match = PveQemuOverview.routeName.firstMatch(context.name);
              final nodeID = match?.group(1);
              final guestID = match?.group(2);

              return MaterialPageRoute(
                fullscreenDialog: false,
                settings: context,
                builder: (_) {
                  return MultiProvider(
                    providers: [
                      Provider<PveQemuOverviewBloc>(
                        create: (context) => PveQemuOverviewBloc(
                          guestID: guestID,
                          apiClient: state.apiClient,
                          init: PveQemuOverviewState.init(nodeID),
                        )..events.add(UpdateQemuStatus()),
                        dispose: (context, bloc) => bloc.dispose(),
                      ),
                      Provider<PveTaskLogBloc>(
                        create: (context) => PveTaskLogBloc(
                            apiClient: state.apiClient,
                            init: PveTaskLogState.init(nodeID))
                          ..events.add(FilterTasksByGuestID(guestID: guestID))
                          ..events.add(LoadTasks()),
                        dispose: (context, bloc) => bloc.dispose(),
                      )
                    ],
                    child: PveQemuOverview(
                      guestID: guestID,
                    ),
                  );
                },
              );
            }
            if (PveLxcOverview.routeName.hasMatch(context.name)) {
              final match = PveLxcOverview.routeName.firstMatch(context.name);
              final nodeID = match?.group(1);
              final guestID = match?.group(2);

              return MaterialPageRoute(
                fullscreenDialog: false,
                settings: context,
                builder: (_) {
                  return MultiProvider(
                    providers: [
                      Provider<PveLxcOverviewBloc>(
                        create: (context) => PveLxcOverviewBloc(
                          guestID: guestID,
                          apiClient: state.apiClient,
                          init: PveLxcOverviewState.init(nodeID),
                        )..events.add(UpdateLxcStatus()),
                        dispose: (context, bloc) => bloc.dispose(),
                      ),
                      Provider<PveTaskLogBloc>(
                        create: (context) => PveTaskLogBloc(
                            apiClient: state.apiClient,
                            init: PveTaskLogState.init(nodeID))
                          ..events.add(FilterTasksByGuestID(guestID: guestID))
                          ..events.add(LoadTasks()),
                        dispose: (context, bloc) => bloc.dispose(),
                      )
                    ],
                    child: PveLxcOverview(
                      guestID: guestID,
                    ),
                  );
                },
              );
            }

            if (PveNodeOverview.routeName.hasMatch(context.name)) {
              final match = PveNodeOverview.routeName.firstMatch(context.name);
              final nodeID = match?.group(1);
              return MaterialPageRoute(
                fullscreenDialog: false,
                settings: context,
                builder: (context) {
                  final rbloc = Provider.of<PveResourceBloc>(context);
                  return MultiProvider(
                    providers: [
                      Provider<PveNodeOverviewBloc>(
                        create: (context) => PveNodeOverviewBloc(
                          apiClient: state.apiClient,
                          nodeID: nodeID,
                          init: PveNodeOverviewState.init(
                              rbloc.latestState.isStandalone),
                        )..events.add(UpdateNodeStatus()),
                        dispose: (context, bloc) => bloc.dispose(),
                      ),
                      Provider<PveTaskLogBloc>(
                        create: (context) => PveTaskLogBloc(
                            apiClient: state.apiClient,
                            init: PveTaskLogState.init(nodeID))
                          ..events.add(LoadTasks()),
                        dispose: (context, bloc) => bloc.dispose(),
                      )
                    ],
                    child: PveNodeOverview(
                      nodeID: nodeID,
                    ),
                  );
                },
              );
            }
            switch (context.name) {
              case '/':
                return MaterialPageRoute(
                  fullscreenDialog: true,
                  settings: context,
                  builder: (context) => MultiProvider(
                    providers: [
                      Provider<proxclient.ProxmoxApiClient>.value(
                        value: state.apiClient,
                      ),
                      Provider<PveClusterStatusBloc>(
                        create: (context) => PveClusterStatusBloc(
                            apiClient: state.apiClient,
                            init: PveClusterStatusState.init())
                          ..events.add(UpdateClusterStatus()),
                        dispose: (context, bloc) => bloc.dispose(),
                      )
                    ],
                    child: ProxmoxLayoutBuilder(
                      builder: (context, layout) => layout != ProxmoxLayout.slim
                          ? MainLayoutWide()
                          : MainLayoutSlim(),
                    ),
                  ),
                );
                break;
              case PveCreateVmWizard.routeName:
                return MaterialPageRoute(
                  fullscreenDialog: true,
                  settings: context,
                  builder: (_) {
                    return Provider<proxclient.ProxmoxApiClient>.value(
                        value: state.apiClient, child: PveCreateVmWizard());
                  },
                );
                break;

              case PveConsoleWidget.routeName:
                return MaterialPageRoute(
                  fullscreenDialog: true,
                  settings: context,
                  builder: (_) {
                    return Provider<proxclient.ProxmoxApiClient>.value(
                        value: state.apiClient,
                        child: PveConsoleWidget(
                          nodeid: 'localhost',
                        ));
                  },
                );
                break;

              default:
                return MaterialPageRoute(
                  settings: context,
                  builder: (context) {
                    return NotFoundPage();
                  },
                );
            }
          }
        },
        initialRoute: '/',
      ),
    );
  }
}
