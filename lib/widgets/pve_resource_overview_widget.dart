import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proxmox_dart_api_client/proxmox_dart_api_client.dart';
import 'package:pve_flutter_frontend/bloc/pve_resource_bloc.dart';
import 'package:pve_flutter_frontend/utils/renderers.dart';

class PveResourceOverview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final rbloc = Provider.of<PveResourceBloc>(context);
    return StreamBuilder<PveResourceState>(
        stream: rbloc.state,
        initialData: rbloc.state.value,
        builder: (context, snapshot) => SingleChildScrollView(
              child: DataTable(
                columns: [
                  DataColumn(
                    label: Text("Type"),
                  ),
                  DataColumn(
                    label: Text("Description"),
                  ),
                  DataColumn(
                    label: Text("Node"),
                  ),
                  DataColumn(
                    label: Text("Action"),
                  ),
                ],
                rows: snapshot.data.resources
                    .where((resource) => resource.type != "pool")
                    .map((resource) => DataRow(cells: [
                          DataCell(Renderers.getDefaultResourceIcon(
                              resource.type, resource.shared, resource.status)),
                          DataCell(Text(resource.displayName)),
                          DataCell(Text(resource.node ?? "")),
                          DataCell(Row(
                            children: getResourceActions(resource, rbloc),
                          ))
                        ]))
                    .toList(),
              ),
            ));
  }

  List<Widget> getResourceActions(
      PveClusterResourcesModel resource, PveResourceBloc rbloc) {
    switch (resource.type) {
      case "node":
        if (resource.status == "online") {
          return [
            IconButton(
              icon: Icon(
                Icons.power_settings_new,
                color: Colors.red,
              ),
              tooltip: "Turn off",
              onPressed: () => rbloc.events.add(
                  PerformActionOnResource(ResourceAction.shutdown, resource)),
            ),
            IconButton(
              icon: Icon(
                Icons.autorenew,
              ),
              tooltip: "Reboot",
              onPressed: () => rbloc.events.add(
                  PerformActionOnResource(ResourceAction.reboot, resource)),
            ),
          ];
        }
        return [];

      case "qemu":
        if (resource.status == "running") {
          return [
            IconButton(
              icon: Icon(
                Icons.power_settings_new,
                color: Colors.red,
              ),
              onPressed: () => rbloc.events.add(
                  PerformActionOnResource(ResourceAction.shutdown, resource)),
              tooltip: "Shutdown",
            ),
            IconButton(
              icon: Icon(
                Icons.power,
                color: Colors.red,
              ),
              tooltip: "Unplug",
              onPressed: () => rbloc.events
                  .add(PerformActionOnResource(ResourceAction.stop, resource)),
            ),
          ];
        }
        return [
          IconButton(
            icon: Icon(
              Icons.power_settings_new,
              color: Colors.green,
            ),
            onPressed: () => rbloc.events
                .add(PerformActionOnResource(ResourceAction.start, resource)),
            tooltip: "Start",
          ),
        ];

      case "lxc":
        if (resource.status == "running") {
          return [
            IconButton(
              icon: Icon(
                Icons.power_settings_new,
                color: Colors.red,
              ),
              onPressed: () => rbloc.events
                  .add(PerformActionOnResource(ResourceAction.stop, resource)),
              tooltip: "Shutdown",
            ),
            IconButton(
              icon: Icon(
                Icons.power,
                color: Colors.red,
              ),
              tooltip: "Unplug",
              onPressed: () => rbloc.events.add(
                  PerformActionOnResource(ResourceAction.shutdown, resource)),
            ),
          ];
        }
        return [
          IconButton(
            icon: Icon(
              Icons.power_settings_new,
              color: Colors.green,
            ),
            tooltip: "Start",
            onPressed: () => rbloc.events
                .add(PerformActionOnResource(ResourceAction.start, resource)),
          )
        ];
      case "storage":
        return [];
      case "pool":
        return [];
      default:
        return [];
    }
  }
}