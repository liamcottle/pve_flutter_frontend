import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:proxmox_dart_api_client/proxmox_dart_api_client.dart';
import 'package:pve_flutter_frontend/bloc/pve_migrate_bloc.dart';
import 'package:pve_flutter_frontend/bloc/pve_node_selector_bloc.dart';
import 'package:pve_flutter_frontend/bloc/pve_resource_bloc.dart';
import 'package:pve_flutter_frontend/states/pve_migrate_state.dart';
import 'package:pve_flutter_frontend/states/pve_node_selector_state.dart';
import 'package:pve_flutter_frontend/widgets/proxmox_stream_builder_widget.dart';
import 'package:pve_flutter_frontend/widgets/pve_guest_migration_connector_widget.dart';
import 'package:pve_flutter_frontend/widgets/pve_help_icon_button_widget.dart';

class PveGuestMigrate extends StatelessWidget {
  PveGuestMigrate({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final migrateBloc = Provider.of<PveMigrateBloc>(context);
    final nodeSelectorbloc = Provider.of<PveNodeSelectorBloc>(context);
    final colorScheme = Theme.of(context).colorScheme;

    return ProxmoxStreamBuilder<PveMigrateBloc, PveMigrateState>(
      bloc: migrateBloc,
      builder: (context, migrateState) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              "Migration",
              style: TextStyle(color: Colors.white, fontSize: 25),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            leading: IconButton(
              icon: Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
            ),
            elevation: 0.0,
            actions: <Widget>[
              PveHelpIconButton(
                  baseUrl: (Provider.of<PveResourceBloc>(context)
                          .apiClient
                          ?.credentials
                          .apiBaseUrl ??
                      Uri.parse('https://pve.proxmox.com/')),
                  docPath: 'chapter-qm.html') // FIXME: '#anchor' is url encoded
            ],
          ),
          body: PveMigrateStreamConnector(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  color: colorScheme.primary,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          leading: Icon(FontAwesomeIcons.globe),
                          title: Text(
                            'Mode',
                            style: TextStyle(color: colorScheme.onPrimary),
                          ),
                          subtitle: Text(
                            migrateState.mode.name,
                            style: TextStyle(
                                color: colorScheme.onPrimary.withOpacity(0.66)),
                          ),
                        ),
                        ListTile(
                          leading: Icon(FontAwesomeIcons.mapPin),
                          title: Text(
                            'Source',
                            style: TextStyle(color: colorScheme.onPrimary),
                          ),
                          subtitle: Text(
                            migrateState.nodeID,
                            style: TextStyle(
                                color: colorScheme.onPrimary.withOpacity(0.66)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: _MigrateTargetSelector(
                            titleColor: colorScheme.onPrimary,
                            iconEnabledColor: colorScheme.onPrimary,
                            nodeSelectorbloc: nodeSelectorbloc,
                            migrateBloc: migrateBloc,
                            disabled: migrateState.inProgress,
                          ),
                        )
                      ]),
                ),
                if (migrateState.inProgress) LinearProgressIndicator(),
                if (migrateState.preconditions != null)
                  Expanded(
                    child: ListView(
                      children: [
                        for (var con in migrateState.preconditions!)
                          ListTile(
                            leading: con.severity == PveMigrateSeverity.error
                                ? Icon(
                                    Icons.error,
                                    color: colorScheme.error,
                                  )
                                : Icon(
                                    Icons.warning,
                                    color: Colors.orange,
                                  ),
                            title: Text(con.message),
                          )
                      ],
                    ),
                  )
              ],
            ),
          ),
          floatingActionButton: _disableStartButton(migrateState)
              ? null
              : FloatingActionButton.extended(
                  onPressed: () {
                    migrateBloc.events.add(StartMigration());
                    nodeSelectorbloc.events.add(ResetNodeSelector());
                  },
                  label: migrateState.inProgress ? Text('') : Text('Start'),
                  icon: migrateState.inProgress
                      ? Icon(Icons.more_horiz)
                      : Icon(Icons.send)),
        );
      },
    );
  }

  bool _disableStartButton(PveMigrateState state) {
    return (state.preconditions
                ?.any((p) => p.severity == PveMigrateSeverity.error) ??
            false) ||
        state.inProgress;
  }
}

class _MigrateTargetSelector extends StatelessWidget {
  const _MigrateTargetSelector({
    Key? key,
    required this.nodeSelectorbloc,
    required this.migrateBloc,
    required this.disabled,
    required this.titleColor,
    required this.iconEnabledColor,
  }) : super(key: key);

  final PveNodeSelectorBloc nodeSelectorbloc;
  final PveMigrateBloc migrateBloc;
  final bool disabled;
  final Color titleColor;
  final Color? iconEnabledColor;

  @override
  Widget build(BuildContext context) {
    return ProxmoxStreamBuilder<PveNodeSelectorBloc, PveNodeSelectorState>(
      bloc: Provider.of<PveNodeSelectorBloc>(context),
      builder: (context, state) {
        return ListTile(
          leading: Icon(Icons.fiber_new),
          title: Text(
            'Target',
            style: TextStyle(color: titleColor),
          ),
          subtitle: DropdownButtonFormField(
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: titleColor)),
            ),
            iconEnabledColor: iconEnabledColor,
            items: state.availableNodes
                .map((item) => DropdownMenuItem(
                      child: ListTile(
                        leading: Icon(
                          Icons.storage,
                        ),
                        trailing:
                            Icon(Icons.offline_bolt, color: Colors.green[500]),
                        title: Text(item.nodeName),
                        subtitle:
                            Text('CPU: ${item.renderMemoryUsagePercent()}'),
                      ),
                      value: item.nodeName,
                    ))
                .toList(),
            selectedItemBuilder: (context) =>
                getSelectedItem(state.availableNodes),
            onChanged: disabled
                ? null
                : (String? selectedNode) {
                    nodeSelectorbloc.events
                        .add(NodeSelectedEvent(selectedNode));

                    migrateBloc.events
                        .add(MigrationTargetChanged(selectedNode));
                  },
            value: state.selectedNode?.nodeName,
            isExpanded: true,
          ),
        );
      },
    );
  }

  // you ask why? if not, the height of the dropdown isn't constant
  List<Widget> getSelectedItem(List<PveNodesModel> nodes) {
    if (nodes.isNotEmpty)
      return nodes
          .map((item) => Row(children: [
                Text(
                  item.nodeName,
                  style: TextStyle(
                    color: titleColor,
                    fontSize: 14,
                  ),
                )
              ]))
          .toList();
    return [Text('')];
  }
}
