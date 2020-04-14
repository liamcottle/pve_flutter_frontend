import 'package:flutter/material.dart';
import 'package:pve_flutter_frontend/bloc/pve_lxc_overview_bloc.dart';
import 'package:pve_flutter_frontend/states/pve_lxc_overview_state.dart';
import 'package:pve_flutter_frontend/widgets/proxmox_stream_builder_widget.dart';

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
                    SwitchListTile(
                      title: Text("Start on boot"),
                      value: config.onboot ?? false,
                      onChanged: (v) => null,
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
                    SwitchListTile(
                      title: Text("/dev/console"),
                      value: config.console ?? false,
                      onChanged: (v) => null,
                    ),
                    ListTile(
                      title: Text("TTY Count"),
                      subtitle: Text("${config.tty ?? 2}"),
                    ),
                    ListTile(
                      title: Text("Console Mode"),
                      subtitle: Text(config.cmode?.name ?? 'tty'),
                    ),
                    SwitchListTile(
                      title: Text("Protection"),
                      value: config.protection ?? false,
                      onChanged: (v) => null,
                    ),
                    SwitchListTile(
                      title: Text("Unprivileged"),
                      value: config.unprivileged ?? true,
                      onChanged: (v) => null,
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
