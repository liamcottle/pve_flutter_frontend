import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pve_flutter_frontend/widgets/pve_first_welcome_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:proxmox_login_manager/proxmox_login_manager.dart';
import 'package:pve_flutter_frontend/bloc/pve_authentication_bloc.dart';
import 'package:pve_flutter_frontend/bloc/pve_cluster_status_bloc.dart';
import 'package:pve_flutter_frontend/bloc/pve_lxc_overview_bloc.dart';
import 'package:pve_flutter_frontend/bloc/pve_node_overview_bloc.dart';
import 'package:pve_flutter_frontend/bloc/pve_qemu_overview_bloc.dart';
import 'package:pve_flutter_frontend/bloc/pve_resource_bloc.dart';
import 'package:pve_flutter_frontend/bloc/pve_task_log_bloc.dart';
import 'package:pve_flutter_frontend/pages/404_page.dart';
import 'package:pve_flutter_frontend/pages/main_layout_slim.dart';
import 'package:pve_flutter_frontend/states/pve_cluster_status_state.dart';
import 'package:pve_flutter_frontend/states/pve_lxc_overview_state.dart';
import 'package:pve_flutter_frontend/states/pve_node_overview_state.dart';
import 'package:pve_flutter_frontend/states/pve_qemu_overview_state.dart';
import 'package:pve_flutter_frontend/states/pve_resource_state.dart';
import 'package:pve_flutter_frontend/states/pve_task_log_state.dart';
import 'package:pve_flutter_frontend/widgets/proxmox_stream_listener.dart';
import 'package:proxmox_dart_api_client/proxmox_dart_api_client.dart'
    as proxclient;

import 'package:pve_flutter_frontend/utils/proxmox_layout_builder.dart';

import 'package:pve_flutter_frontend/bloc/proxmox_global_error_bloc.dart';
import 'package:pve_flutter_frontend/widgets/pve_lxc_overview.dart';
import 'package:pve_flutter_frontend/widgets/pve_node_overview.dart';
import 'package:pve_flutter_frontend/widgets/pve_qemu_overview.dart';
import 'package:pve_flutter_frontend/widgets/pve_splash_screen.dart';
import 'package:pve_flutter_frontend/utils/proxmox_colors.dart';

import 'package:rxdart/streams.dart' show ValueStreamExtensions;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final authBloc = PveAuthenticationBloc();
  try {
    final loginStorage = await (ProxmoxLoginStorage.fromLocalStorage()
        as FutureOr<ProxmoxLoginStorage>);
    final apiClient = await loginStorage.recoverLatestSession();
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
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
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
        sharedPreferences: sharedPreferences,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final PveAuthenticationBloc? authbloc;
  final SharedPreferences sharedPreferences;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  MyApp({Key? key, this.authbloc, required this.sharedPreferences})
      : assert(sharedPreferences != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamListener<PveAuthenticationState>(
      stream: authbloc!.state,
      onStateChange: (state) {
        if (state is Authenticated) {
          Provider.of<PveResourceBloc>(context, listen: false)
            ..apiClient = state.apiClient
            ..events.add(PollResources());
        }
        if (state is Unauthenticated) {
          Provider.of<PveResourceBloc>(context, listen: false)
            ..apiClient = null;
        }
      },
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: 'Proxmox',
        //themeMode: ThemeMode.dark, // comment in/out to test
        theme: ThemeData(
          colorScheme: ColorScheme.light(
            brightness: Brightness.light,
            primary: ProxmoxColors.supportBlue,
            onPrimary: Colors.white,
            primaryVariant: ProxmoxColors.blue900,
            secondary: ProxmoxColors.orange,
            secondaryVariant: ProxmoxColors.supportLightOrange,
            surface: ProxmoxColors.supportGreyTint50,
            onSurface: Colors.black,
            background: ProxmoxColors.supportGreyTint75,
            onBackground: Colors.black,
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(primary: ProxmoxColors.grey),
          ),
          fontFamily: "Open Sans",
          primaryTextTheme: TextTheme(
            headline6:
                TextStyle(fontFamily: "Open Sans", fontWeight: FontWeight.w700),
          ),
          appBarTheme: AppBarTheme(
            backgroundColor: ProxmoxColors.supportBlue, // primary
            foregroundColor: Colors.white, // onPrimary
          ),
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.dark(
            brightness: Brightness.dark,
            primary: ProxmoxColors.supportBlue,
            onPrimary: Colors.white,
            primaryVariant: ProxmoxColors.blue800,
            surface: ProxmoxColors.greyTint20,
            onSurface: Colors.white,
            secondary: ProxmoxColors.orange,
            secondaryVariant: ProxmoxColors.supportLightOrange,
            background: ProxmoxColors.grey,
            onBackground: ProxmoxColors.supportGreyTint75,
          ),
          // flutter has a weird logic where it pulls colors from different
          // scheme properties depending on light/dark mode, avoid that...
          appBarTheme: AppBarTheme(
            backgroundColor: ProxmoxColors.supportBlue, // primary
            foregroundColor: Colors.white, // onPrimary
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(primary: ProxmoxColors.greyTint80),
          ),
          fontFamily: "Open Sans",
          primaryTextTheme: TextTheme(
            headline6:
                TextStyle(fontFamily: "Open Sans", fontWeight: FontWeight.w700),
          ),
          scaffoldBackgroundColor: ProxmoxColors.grey,
        ),
        builder: (context, child) {
          return StreamListener(
            stream: ProxmoxGlobalErrorBloc().onError.distinct(),
            onStateChange: (dynamic error) async {
              if (!ProxmoxGlobalErrorBloc().dialogVisible) {
                ProxmoxGlobalErrorBloc().dialogVisible = true;

                await showDialog<String>(
                  context: navigatorKey.currentState!.overlay!.context,
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
          if (authbloc!.state.value is Uninitialized) {
            return MaterialPageRoute(
              builder: (context) => PveSplashScreen(),
            );
          }
          if (sharedPreferences.getBool('showWelcomeScreen') ?? true) {
            return MaterialPageRoute(
              builder: (context) => PveWelcome(),
            );
          }

          if (authbloc!.state.value is Unauthenticated ||
              context.name == '/login') {
            return MaterialPageRoute(
              builder: (context) {
                return StreamListener<PveAuthenticationState>(
                  stream: authbloc!.state,
                  onStateChange: (state) {
                    if (state is Authenticated) {
                      Navigator.of(context).pushReplacementNamed('/');
                    }
                  },
                  child: ProxmoxLoginSelector(
                    onLogin: (client) => authbloc!.events.add(LoggedIn(client)),
                  ),
                );
              },
            );
          }
          if (authbloc!.state.value is Authenticated) {
            final state = authbloc!.state.value as Authenticated;
            if (PveQemuOverview.routeName.hasMatch(context.name!)) {
              final match =
                  PveQemuOverview.routeName.firstMatch(context.name!)!;
              final String nodeID = match.group(1)!;
              final String guestID = match.group(2)!;

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
            if (PveLxcOverview.routeName.hasMatch(context.name!)) {
              final match = PveLxcOverview.routeName.firstMatch(context.name!)!;
              final String nodeID = match.group(1)!;
              final String guestID = match.group(2)!;

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

            if (PveNodeOverview.routeName.hasMatch(context.name!)) {
              final match =
                  PveNodeOverview.routeName.firstMatch(context.name!)!;
              final String nodeID = match.group(1)!;
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
                    //TODO add a wide layout option here when it's ready
                    child: ProxmoxLayoutBuilder(
                      builder: (context, layout) => layout != ProxmoxLayout.slim
                          ? MainLayoutSlim()
                          : MainLayoutSlim(),
                    ),
                  ),
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
          return MaterialPageRoute(
            settings: context,
            builder: (context) {
              return NotFoundPage();
            },
          );
        },
        initialRoute: '/',
      ),
    );
  }
}
