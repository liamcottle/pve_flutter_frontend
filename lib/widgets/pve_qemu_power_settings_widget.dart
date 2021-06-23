import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:proxmox_dart_api_client/proxmox_dart_api_client.dart';
import 'package:pve_flutter_frontend/bloc/pve_qemu_overview_bloc.dart';
import 'package:pve_flutter_frontend/states/pve_qemu_overview_state.dart';
import 'package:pve_flutter_frontend/widgets/proxmox_stream_builder_widget.dart';

class PveQemuPowerSettings extends StatelessWidget {
  const PveQemuPowerSettings({
    Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<PveQemuOverviewBloc>(context);
    return ProxmoxStreamBuilder<PveQemuOverviewBloc, PveQemuOverviewState>(
        bloc: bloc,
        builder: (context, state) {
          final qemuStatus = state.currentStatus?.getQemuStatus();
          final disableShutdown = qemuStatus != PveResourceStatusType.running;
          return SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height / 3),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if (qemuStatus == PveResourceStatusType.stopped &&
                      !(state.currentStatus.template ?? false))
                    ListTile(
                      leading: Icon(Icons.play_arrow),
                      title: Text(
                        "Start",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text("Turn on QEMU virtual machine"),
                      onTap: () =>
                          action(context, PveClusterResourceAction.start, bloc),
                    ),
                  if ([
                        PveResourceStatusType.paused,
                        PveResourceStatusType.suspended
                      ].contains(qemuStatus) &&
                      !(state.currentStatus.template ?? false))
                    ListTile(
                      leading: Icon(Icons.play_arrow),
                      title: Text(
                        "Resume",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text("Resume QEMU virtual machine"),
                      onTap: () => action(
                          context, PveClusterResourceAction.resume, bloc),
                    ),
                  if (!disableShutdown) ...[
                    ListTile(
                      leading: Icon(Icons.power_settings_new),
                      title: Text(
                        "Shutdown",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text("Shutdown QEMU virtual machine"),
                      onTap: () => action(
                          context, PveClusterResourceAction.shutdown, bloc),
                    ),
                    ListTile(
                      leading: Icon(Icons.autorenew),
                      title: Text(
                        "Reboot",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text("Reboot QEMU virtual machine"),
                      onTap: () => action(
                          context, PveClusterResourceAction.reboot, bloc),
                    ),
                    ListTile(
                      leading: Icon(Icons.pause),
                      title: Text(
                        "Pause",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text("Pause QEMU virtual machine"),
                      onTap: () => action(
                          context, PveClusterResourceAction.suspend, bloc),
                    ),
                    ListTile(
                      leading: Icon(FontAwesomeIcons.download),
                      title: Text(
                        "Hibernate",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text("Hibernate QEMU virtual machine"),
                      onTap: () => action(
                          context, PveClusterResourceAction.hibernate, bloc),
                    ),
                    ListTile(
                      leading: Icon(Icons.stop),
                      title: Text(
                        "Stop",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text("Stop QEMU virtual machine"),
                      onTap: () =>
                          action(context, PveClusterResourceAction.stop, bloc),
                    ),
                    ListTile(
                      leading: Icon(FontAwesomeIcons.bolt),
                      title: Text(
                        "Reset",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text("Reset QEMU virtual machine"),
                      onTap: () =>
                          action(context, PveClusterResourceAction.reset, bloc),
                    ),
                  ],
                ],
              ),
            ),
          );
        });
  }

  void action(BuildContext context, PveClusterResourceAction action,
      PveQemuOverviewBloc bloc) {
    bloc.events.add(PerformQemuAction(action));
    Navigator.of(context).pop();
  }
}
