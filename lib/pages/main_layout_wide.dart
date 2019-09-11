import 'package:flutter/material.dart';
import 'package:pve_flutter_frontend/widgets/pve_main_navigation_drawer.dart';
import 'package:pve_flutter_frontend/widgets/pve_task_log_widget.dart';

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
        body: Container()
        );
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
                child: PVETaskLog()));
      },
    );
  }
}
