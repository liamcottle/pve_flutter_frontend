import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pve_flutter_frontend/bloc/pve_task_log_bloc.dart';
import 'package:pve_flutter_frontend/widgets/pve_main_navigation_drawer.dart';
import 'package:pve_flutter_frontend/widgets/pve_task_log_widget.dart';
import 'package:proxmox_dart_api_client/proxmox_dart_api_client.dart'
    as proxclient;

class MainLayoutWide extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: PveMainNavigationDrawer(),
        appBar: AppBar(
          title: Text("Proxmox"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.help),
              tooltip: "Documantation",
              onPressed: () {
                // html.window.open(
                //     "https://pve.proxmox.com/pve-docs/pve-admin-guide.html",
                //     "Documentation");
              },
            ),
            LogButton()
          ],
        ),
        body: Container());
  }
}

class LogButton extends StatelessWidget {
  const LogButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.view_list),
      tooltip: "Cluster logs",
      onPressed: () {
        showBottomSheet(
            context: context,
            builder: (context) => Container(
                height: MediaQuery.of(context).size.height * 0.25,
                width: MediaQuery.of(context).size.width,
                child: PVETaskLog(
                    bloc: PveTaskLogBloc(
                        apiClient: Provider.of<proxclient.Client>(context)))));
      },
    );
  }
}
