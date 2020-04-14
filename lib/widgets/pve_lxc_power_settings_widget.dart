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
                    if (disableShutdown)
                      OutlineButton.icon(
                        onPressed: () => action(
                            context, PveClusterResourceAction.start, lxcBloc),
                        icon: Icon(Icons.play_arrow),
                        label: Text("Start"),
                      ),
                    OutlineButton.icon(
                      onPressed: disableShutdown
                          ? null
                          : () => action(context,
                              PveClusterResourceAction.shutdown, lxcBloc),
                      icon: Icon(Icons.power_settings_new),
                      label: Text("Shutdown"),
                    ),
                    OutlineButton.icon(
                      onPressed: disableShutdown
                          ? null
                          : () => action(context,
                              PveClusterResourceAction.reboot, lxcBloc),
                      icon: Icon(Icons.autorenew),
                      label: Text("Reboot"),
                    ),
                    OutlineButton.icon(
                      onPressed: disableShutdown
                          ? null
                          : () => action(
                              context, PveClusterResourceAction.stop, lxcBloc),
                      icon: Icon(Icons.stop),
                      label: Text("Stop"),
                    ),
                  ],
                ),
              ),
            ],
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
