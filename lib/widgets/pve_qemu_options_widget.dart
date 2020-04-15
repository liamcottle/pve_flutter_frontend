import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pve_flutter_frontend/bloc/pve_qemu_overview_bloc.dart';
import 'package:pve_flutter_frontend/states/pve_qemu_overview_state.dart';
import 'package:pve_flutter_frontend/widgets/proxmox_stream_builder_widget.dart';

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
                        subtitle: Text(
                            "${config.ostype.type} ${config.ostype.description}"),
                      ),
                      //TODO add better ui component e.g. collapseable
                      ListTile(
                        title: Text("Boot Device"),
                        subtitle: Text(config.boot ?? 'Disk, Network, USB'),
                      ),
                      SwitchListTile(
                        title: Text("Use tablet for pointer"),
                        value: config.tablet ?? true,
                        onChanged: (v) => null,
                      ),
                      ListTile(
                        title: Text("Hotplug"),
                        subtitle: Text(config.hotplug ?? 'disk,network,usb'),
                      ),
                      SwitchListTile(
                        title: Text("ACPI support"),
                        value: config.acpi ?? true,
                        onChanged: (v) => null,
                      ),
                      SwitchListTile(
                        title: Text("KVM hardware virtualization"),
                        value: config.kvm ?? true,
                        onChanged: (v) => null,
                      ),
                      SwitchListTile(
                        title: Text("Freeze CPU on startup"),
                        value: config.freeze ?? false,
                        onChanged: (v) => null,
                      ),
                      SwitchListTile(
                        title: Text("Use local time for RTC"),
                        value: config.localtime ?? false,
                        onChanged: (v) => null,
                      ),
                      ListTile(
                        title: Text("RTC start date"),
                        subtitle: Text(config.startdate ?? 'now'),
                      ),
                      ListTile(
                        title: Text("SMBIOS settings (type1)"),
                        subtitle: Text(config.smbios1 ?? ''),
                      ),
                      ListTile(
                        title: Text("QEMU Guest Agent"),
                        subtitle: Text(config.agent ?? 'Default (disabled)'),
                      ),
                      SwitchListTile(
                        title: Text("Use local time for RTC"),
                        value: config.protection ?? false,
                        onChanged: (v) => null,
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
              floatingActionButton: FloatingActionButton.extended(
                  onPressed: null, label: Text("Save"), icon: Icon(Icons.save)),
              extendBody: true,
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}