import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:proxmox_dart_api_client/proxmox_dart_api_client.dart';
import 'package:pve_flutter_frontend/bloc/pve_lxc_overview_bloc.dart';
import 'package:pve_flutter_frontend/states/pve_lxc_overview_state.dart';
import 'package:pve_flutter_frontend/widgets/proxmox_stream_builder_widget.dart';

class PveLxcPowerSettings extends StatelessWidget {
  final PveLxcOverviewBloc lxcBloc;

  const PveLxcPowerSettings({Key key, this.lxcBloc}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ProxmoxStreamBuilder<PveLxcOverviewBloc, PveLxcOverviewState>(
      bloc: lxcBloc,
      builder: (context, state) {
        final status = state.currentStatus;
        final disableShutdown =
            status?.getLxcStatus() != PveResourceStatusType.running;
        return SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height / 3),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (disableShutdown)
                  ListTile(
                    leading: Icon(Icons.play_arrow),
                    title: Text(
                      "Start",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text("Turn on LXC container"),
                    onTap: () => action(
                        context, PveClusterResourceAction.start, lxcBloc),
                  ),
                if (!disableShutdown) ...[
                  ListTile(
                    leading: Icon(Icons.power_settings_new),
                    title: Text(
                      "Shutdown",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text("Turn off LXC container"),
                    onTap: () => action(
                        context, PveClusterResourceAction.shutdown, lxcBloc),
                  ),
                  ListTile(
                    leading: Icon(Icons.loop),
                    title: Text(
                      "Reboot",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text("Reboot LXC container"),
                    onTap: () => action(
                        context, PveClusterResourceAction.reboot, lxcBloc),
                  ),
                  ListTile(
                    leading: Icon(Icons.stop),
                    title: Text(
                      "Stop",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text("Stop LXC container"),
                    onTap: () =>
                        action(context, PveClusterResourceAction.stop, lxcBloc),
                  ),
                ]
              ],
            ),
          ),
        );
      },
    );
  }

  void action(BuildContext context, PveClusterResourceAction action,
      PveLxcOverviewBloc bloc) {
    bloc.events.add(PerformLxcAction(action));
    Navigator.of(context).pop();
  }
}
