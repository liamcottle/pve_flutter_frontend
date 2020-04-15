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
          final qemuStatus = state.currentStatus.getQemuStatus();
          final disableShutdown = qemuStatus != PveResourceStatusType.running;
          return Scaffold(
          backgroundColor: Color(0xFF00617F),
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            body: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Power Settings",
                      style: Theme.of(context)
                          .textTheme
                          .headline4
                          .copyWith(color: Colors.white),
                    ),
                  ],
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      if (qemuStatus == PveResourceStatusType.stopped &&
                          state.currentStatus.template.isEmpty)
                        OutlineButton.icon(
                          onPressed: () => action(
                              context, PveClusterResourceAction.start, bloc),
                          icon: Icon(Icons.play_arrow),
                          label: Text("Start"),
                        ),
                      if ([
                            PveResourceStatusType.paused,
                            PveResourceStatusType.suspended
                          ].contains(qemuStatus) &&
                          state.currentStatus.template.isEmpty)
                        OutlineButton.icon(
                          onPressed: () => action(
                              context, PveClusterResourceAction.resume, bloc),
                          icon: Icon(Icons.play_arrow),
                          label: Text("Resume"),
                        ),
                      OutlineButton.icon(
                        onPressed: disableShutdown
                            ? null
                            : () => action(context,
                                PveClusterResourceAction.shutdown, bloc),
                        icon: Icon(Icons.power_settings_new),
                        label: Text("Shutdown"),
                      ),
                      OutlineButton.icon(
                        onPressed: disableShutdown
                            ? null
                            : () => action(
                                context, PveClusterResourceAction.reboot, bloc),
                        icon: Icon(Icons.autorenew),
                        label: Text("Reboot"),
                      ),
                      OutlineButton.icon(
                        onPressed: disableShutdown
                            ? null
                            : () => action(context,
                                PveClusterResourceAction.suspend, bloc),
                        icon: Icon(Icons.pause),
                        label: Text("Pause"),
                      ),
                      OutlineButton.icon(
                        onPressed: disableShutdown
                            ? null
                            : () => action(context,
                                PveClusterResourceAction.hibernate, bloc),
                        icon: Icon(FontAwesomeIcons.download),
                        label: Text("Hibernate"),
                      ),
                      OutlineButton.icon(
                        onPressed: disableShutdown
                            ? null
                            : () => action(
                                context, PveClusterResourceAction.stop, bloc),
                        icon: Icon(Icons.stop),
                        label: Text("Stop"),
                      ),
                      OutlineButton.icon(
                        onPressed: disableShutdown
                            ? null
                            : () => action(
                                context, PveClusterResourceAction.reset, bloc),
                        icon: Icon(FontAwesomeIcons.bolt),
                        label: Text("Reset"),
                      )
                    ],
                  ),
                ),
              ],
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
