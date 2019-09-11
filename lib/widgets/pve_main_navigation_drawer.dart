import 'package:flutter/material.dart';
import 'package:pve_flutter_frontend/widgets/proxmox_tree_widget.dart';

class PveMainNavigationDrawer extends StatelessWidget {
  const PveMainNavigationDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: <Widget>[
            TabBar(
              tabs: <Widget>[
                Tab(
                  child: Text(
                    "Tree",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                Tab(
                  child: Text(
                    "Actions",
                    style: TextStyle(color: Colors.black),
                  ),
                )
              ],
            ),
            Expanded(
              child: TabBarView(
                children: <Widget>[
                  ProxmoxTreeWidget(),
                  ListView(
                    children: <Widget>[
                      DrawerHeader(
                        child: ListTile(
                          leading: Icon(Icons.cloud),
                          title: Text("Datacenter"),
                          trailing: PopupMenuButton(
                            icon: Icon(Icons.settings),
                            itemBuilder: (BuildContext context) =>
                                <PopupMenuEntry>[
                              PopupMenuItem(
                                value: 1,
                                child: ListTile(
                                  title: Text('Settings'),
                                  onTap: () {
                                    Navigator.pushNamed(context, '/settings');
                                  },
                                ),
                              ),
                              const PopupMenuItem(
                                value: 2,
                                child: Text('User/Permissions'),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          OutlineButton(
                            child: Text("new VM"),
                            onPressed: () {
                              Navigator.pushNamed(context, '/qemu/create');
                            },
                          ),
                          // TODO General new button or distinct ones??
                          OutlineButton(
                            child: Text("new CT"),
                            onPressed: null,
                          )
                        ],
                      ),
                      ListTile(
                        leading: Icon(Icons.home),
                        title: Text("Overview"),
                      ),
                      ListTile(
                        leading: Icon(Icons.timeline),
                        title: Text("Performance"),
                      ),
                      ListTile(
                        leading: Icon(Icons.storage),
                        title: Text("Storage"),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: ListTile(
                          leading: Icon(Icons.line_style),
                          title: Text("Ceph"),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: ListTile(
                          leading: Icon(Icons.content_copy),
                          title: Text("Replication"),
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.save),
                        title: Text("Backup"),
                      ),
                      ListTile(
                        leading: Icon(Icons.security),
                        title: Text("Firewall"),
                      ),
                      ListTile(
                        leading: Icon(Icons.help),
                        title: Text("Support"),
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
