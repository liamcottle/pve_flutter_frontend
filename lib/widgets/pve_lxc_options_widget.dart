import 'package:flutter/material.dart';
import 'package:pve_flutter_frontend/bloc/pve_lxc_overview_bloc.dart';
import 'package:pve_flutter_frontend/states/pve_lxc_overview_state.dart';
import 'package:pve_flutter_frontend/widgets/proxmox_stream_builder_widget.dart';
import 'package:pve_flutter_frontend/widgets/pve_config_switch_list_tile.dart';

class PveLxcOptions extends StatelessWidget {
  final PveLxcOverviewBloc lxcBloc;

  const PveLxcOptions({Key key, this.lxcBloc}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ProxmoxStreamBuilder<PveLxcOverviewBloc, PveLxcOverviewState>(
        bloc: lxcBloc,
        builder: (context, state) {
          final config = state.config;
          if (config != null) {
            return Scaffold(
              appBar: AppBar(),
              body: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    ListTile(
                      title: Text("Name"),
                      subtitle: Text(config.hostname ?? 'undefined'),
                    ),
                    PveConfigSwitchListTile(
                      title: Text("Start on boot"),
                      value: config.onboot,
                      defaultValue: false,
                      pending: config.getPending('onboot'),
                      onChanged: (v) =>
                          lxcBloc.events.add(UpdateLxcConfigBool('onboot', v)),
                      onDeleted: () =>
                          lxcBloc.events.add(RevertPendingLxcConfig('onboot')),
                    ),
                    ListTile(
                      title: Text("Start/Shutdown order"),
                      subtitle: Text(config.startup ?? "Default (any)"),
                    ),
                    ListTile(
                      title: Text("OS Type"),
                      subtitle: Text("${config.ostype}"),
                    ),
                    ListTile(
                      title: Text("Architecture"),
                      subtitle: Text("${config.arch}"),
                    ),
                    PveConfigSwitchListTile(
                      title: Text("/dev/console"),
                      value: config.console,
                      defaultValue: true,
                      pending: config.getPending('console'),
                      onChanged: (v) =>
                          lxcBloc.events.add(UpdateLxcConfigBool('console', v)),
                      onDeleted: () =>
                          lxcBloc.events.add(RevertPendingLxcConfig('console')),
                    ),
                    ListTile(
                      title: Text("TTY Count"),
                      subtitle: Text("${config.tty ?? 2}"),
                    ),
                    ListTile(
                      title: Text("Console Mode"),
                      subtitle: Text(config.cmode?.name ?? 'tty'),
                    ),
                    PveConfigSwitchListTile(
                      title: Text("Protection"),
                      value: config.protection,
                      defaultValue: false,
                      pending: config.getPending('protection'),
                      onChanged: (v) => lxcBloc.events
                          .add(UpdateLxcConfigBool('protection', v)),
                      onDeleted: () => lxcBloc.events
                          .add(RevertPendingLxcConfig('protection')),
                    ),
                    ListTile(
                      title: Text("Unprivileged"),
                      subtitle:
                          Text(config.unprivileged ?? false ? 'Yes' : 'No'),
                    ),
                    ListTile(
                      title: Text("Features"),
                      subtitle: Text(config?.features?.toString() ?? 'none'),
                    ),
                  ],
                ),
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
