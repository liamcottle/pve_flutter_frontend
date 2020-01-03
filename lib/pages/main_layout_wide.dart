import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pve_flutter_frontend/bloc/proxmox_global_error_bloc.dart';
import 'package:pve_flutter_frontend/bloc/pve_task_log_bloc.dart';
import 'package:pve_flutter_frontend/widgets/pve_main_navigation_drawer.dart';
import 'package:pve_flutter_frontend/widgets/pve_resource_overview_widget.dart';
import 'package:pve_flutter_frontend/widgets/pve_task_log_widget.dart';
import 'package:proxmox_dart_api_client/proxmox_dart_api_client.dart';

import 'package:pve_flutter_frontend/bloc/pve_authentication_bloc.dart';

class MainLayoutWide extends StatefulWidget {
  @override
  _MainLayoutWideState createState() => _MainLayoutWideState();
}

class _MainLayoutWideState extends State<MainLayoutWide> {
  StreamSubscription _errorsSubscription;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _errorsSubscription ??= ProxmoxGlobalErrorBloc().onError.listen((error) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(error.toString()),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ));
    });
  }

  @override
  void dispose() {
    _errorsSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final client = Provider.of<ProxmoxApiClient>(context);

    return Scaffold(
        key: _scaffoldKey,
        drawer: PveMainNavigationDrawer(),
        appBar: AppBar(
          title: Text("Proxmox"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.help),
              tooltip: "Documantation",
              onPressed: () {},
            ),
            Provider<PveTaskLogBloc>(
                create: (context) => PveTaskLogBloc(apiClient: client)
                  ..events.add(LoadRecentTasks()),
                dispose: (context, value) => value.dispose(),
                child: LogButton()),
            IconButton(
              icon: Icon(Icons.input),
              tooltip: "Logout",
              onPressed: () => Provider.of<PveAuthenticationBloc>(context).events.add(LoggedOut()),
            )
          ],
        ),
        body: Card(child: PveResourceOverview()));
  }
}

class LogButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final taskBloc = Provider.of<PveTaskLogBloc>(context);
    return IconButton(
      icon: Icon(Icons.view_list),
      tooltip: "Recent Tasks",
      onPressed: () {
        showBottomSheet(
            context: context,
            builder: (otherContext) => Container(
                height: MediaQuery.of(context).size.height * 0.25,
                width: MediaQuery.of(context).size.width,
                child: PVETaskLog(
                  bloc: taskBloc,
                )));
      },
    );
  }
}
