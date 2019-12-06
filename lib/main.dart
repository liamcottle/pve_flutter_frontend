import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pve_flutter_frontend/bloc/pve_authentication_bloc.dart';
import 'package:pve_flutter_frontend/bloc/pve_login_bloc.dart';
import 'package:pve_flutter_frontend/pages/404_page.dart';
import 'package:pve_flutter_frontend/pages/login_page.dart';
import 'package:pve_flutter_frontend/pages/main_layout_slim.dart';
import 'package:pve_flutter_frontend/pages/main_layout_wide.dart';
import 'package:pve_flutter_frontend/states/pve_authentication_states.dart';
import 'package:pve_flutter_frontend/widgets/pve_create_vm_wizard_page.dart';
import 'package:proxmox_dart_api_client/proxmox_dart_api_client.dart'
    as proxclient;

import 'package:pve_flutter_frontend/events/pve_authentication_events.dart';
import 'package:pve_flutter_frontend/utils/proxmox_layout_builder.dart';

void main() async {
  final authBloc = PveAuthenticationBloc();
  try {
    var credentials = proxclient.Credentials.fromPlatformStorage();
    var apiClient = proxclient.Client(credentials);
    apiClient.refreshCredentials();
    authBloc.events.add(LoggedIn(apiClient));
  } catch (_) {
    authBloc.events.add(LoggedOut());
  }

  runApp(MyApp(
    authbloc: authBloc,
  ));
}

class MyApp extends StatelessWidget {
  final PveAuthenticationBloc authbloc;

  MyApp({Key key, this.authbloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Proxmox',
      theme: ThemeData(
          brightness: Brightness.light,
          fontFamily: "Open Sans",
          primarySwatch: Colors.blue,
          primaryTextTheme: TextTheme(
            title:
                TextStyle(fontFamily: "Open Sans", fontWeight: FontWeight.w700),
          )),
      onGenerateRoute: (context) {
        if (authbloc.state.value is Unauthenticated) {
          return MaterialPageRoute(
            builder: (context) {
              return PveLoginPage(
                loginBloc: PveLoginBloc(),
                authenticationBloc: authbloc,
              );
            },
          );
        }
        if (authbloc.state.value is Authenticated) {
          final state = authbloc.state.value as Authenticated;
          switch (context.name) {
            case PveCreateVmWizard.routeName:
              return MaterialPageRoute(
                builder: (_) {
                  return Provider<proxclient.Client>.value(
                      value: state.apiClient,
                      child: PveCreateVmWizard());
                },
              );
            default:
              return MaterialPageRoute(
                builder: (context) {
                  return NotFoundPage();
                },
              );
          }
        }
      },
      home: RootPage(
        authbloc: authbloc,
      ),
    );
  }
}

class RootPage extends StatefulWidget {
  RootPage({Key key, this.authbloc}) : super(key: key);

  final PveAuthenticationBloc authbloc;

  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  PveAuthenticationBloc get _authbloc => widget.authbloc;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: _authbloc.state,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final state = snapshot.data;
            print(state);

            if (state is Unauthenticated) {
              return PveLoginPage(
                loginBloc: PveLoginBloc(),
                authenticationBloc: _authbloc,
              );
            }
            if (state is Authenticated) {
              return Provider<proxclient.Client>.value(
                value: state.apiClient,
                child: ProxmoxLayoutBuilder(
                  builder: (context, layout) => layout != ProxmoxLayout.slim
                      ? MainLayoutWide()
                      : MainLayoutSlim(),
                ),
              );
            }

            if (state is Uninitialized) {
              return Container();
            }
          }
          return Container();
        });
  }
}
