import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pve_flutter_frontend/bloc/pve_qemu_overview_bloc.dart';
import 'package:pve_flutter_frontend/states/pve_qemu_overview_state.dart';
import 'package:pve_flutter_frontend/widgets/proxmox_stream_builder_widget.dart';
import 'package:pve_flutter_frontend/widgets/pve_config_switch_list_tile.dart';

class PveQemuOptions extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  PveQemuOptions({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<PveQemuOverviewBloc>(context);
    return ProxmoxStreamBuilder<PveQemuOverviewBloc, PveQemuOverviewState>(
        bloc: bloc,
        builder: (context, state) {
          if (state.config != null) {
            final config = state.config;
            return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              body: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  onChanged: () {},
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        title: Text("Name"),
                        subtitle: Text(config.name),
                      ),
                      PveConfigSwitchListTile(
                        title: Text("Start on boot"),
                        value: config.onboot,
                        defaultValue: false,
                        pending: config.getPending('onboot'),
                        onChanged: (v) =>
                            bloc.events.add(UpdateQemuConfigBool('onboot', v)),
                        onDeleted: () =>
                            bloc.events.add(RevertPendingQemuConfig('onboot')),
                      ),
                      ListTile(
                        title: Text("Start/Shutdown order"),
                        subtitle: Text(config.startup ?? "Default (any)"),
                      ),
                      ListTile(
                        title: Text("OS Type"),
                        subtitle: Text(
                            "${config.ostype.type} ${config.ostype.description}"),
                      ),
                      //TODO add better ui component e.g. collapseable
                      ListTile(
                        title: Text("Boot Device"),
                        subtitle: Text(config.boot ?? 'Disk, Network, USB'),
                      ),
                      PveConfigSwitchListTile(
                        title: Text("Use tablet for pointer"),
                        value: config.tablet,
                        defaultValue: true,
                        pending: config.getPending('tablet'),
                        onChanged: (v) =>
                            bloc.events.add(UpdateQemuConfigBool('tablet', v)),
                        onDeleted: () =>
                            bloc.events.add(RevertPendingQemuConfig('tablet')),
                      ),
                      ListTile(
                        title: Text("Hotplug"),
                        subtitle: Text(config.hotplug ?? 'disk,network,usb'),
                      ),
                      PveConfigSwitchListTile(
                        title: Text("ACPI support"),
                        value: config.acpi,
                        defaultValue: true,
                        pending: config.getPending('acpi'),
                        onChanged: (v) =>
                            bloc.events.add(UpdateQemuConfigBool('acpi', v)),
                        onDeleted: () =>
                            bloc.events.add(RevertPendingQemuConfig('acpi')),
                      ),
                      PveConfigSwitchListTile(
                        title: Text("KVM hardware virtualization"),
                        value: config.kvm,
                        defaultValue: true,
                        pending: config.getPending('kvm'),
                        onChanged: (v) =>
                            bloc.events.add(UpdateQemuConfigBool('kvm', v)),
                        onDeleted: () =>
                            bloc.events.add(RevertPendingQemuConfig('kvm')),
                      ),
                      PveConfigSwitchListTile(
                        title: Text("Freeze CPU on startup"),
                        value: config.freeze,
                        defaultValue: false,
                        pending: config.getPending('freeze'),
                        onChanged: (v) =>
                            bloc.events.add(UpdateQemuConfigBool('freeze', v)),
                        onDeleted: () =>
                            bloc.events.add(RevertPendingQemuConfig('freeze')),
                      ),
                      PveConfigSwitchListTile(
                        title: Text("Use local time for RTC"),
                        value: config.localtime,
                        defaultValue: false,
                        pending: config.getPending('localtime'),
                        onChanged: (v) => bloc.events
                            .add(UpdateQemuConfigBool('localtime', v)),
                        onDeleted: () => bloc.events
                            .add(RevertPendingQemuConfig('localtime')),
                      ),
                      ListTile(
                        title: Text("RTC start date"),
                        subtitle: Text(config.startdate ?? 'now'),
                      ),
                      ListTile(
                        title: Text("SMBIOS settings (type1)"),
                        subtitle: Text(config.smbios1 ?? ''),
                      ),
                      //Todo enhance UI
                      ListTile(
                        title: Text("QEMU Guest Agent"),
                        subtitle: Text(config.agent ?? 'Default (disabled)'),
                      ),
                      PveConfigSwitchListTile(
                        title: Text("Protection"),
                        value: config.protection,
                        defaultValue: false,
                        pending: config.getPending('protection'),
                        onChanged: (v) => bloc.events
                            .add(UpdateQemuConfigBool('protection', v)),
                        onDeleted: () => bloc.events
                            .add(RevertPendingQemuConfig('protection')),
                      ),
                      ListTile(
                        title: Text("Spice Enhancements"),
                        subtitle:
                            Text(config.spiceEnhancements ?? 'No enhancements'),
                      ),
                      ListTile(
                        title: Text("VM State Storage"),
                        subtitle: Text(config.vmstatestorage ?? 'Automatic'),
                      ),
                    ],
                  ),
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
