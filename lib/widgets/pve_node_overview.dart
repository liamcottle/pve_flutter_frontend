import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:proxmox_dart_api_client/proxmox_dart_api_client.dart';
import 'package:pve_flutter_frontend/bloc/pve_node_overview_bloc.dart';
import 'package:pve_flutter_frontend/bloc/pve_task_log_bloc.dart';
import 'package:pve_flutter_frontend/states/pve_node_overview_state.dart';
import 'package:pve_flutter_frontend/states/pve_task_log_state.dart';
import 'package:pve_flutter_frontend/utils/proxmox_colors.dart';
import 'package:pve_flutter_frontend/utils/renderers.dart';
import 'package:pve_flutter_frontend/utils/utils.dart';
import 'package:pve_flutter_frontend/widgets/proxmox_capacity_indicator.dart';
import 'package:pve_flutter_frontend/widgets/proxmox_stream_builder_widget.dart';
import 'package:pve_flutter_frontend/widgets/pve_action_card_widget.dart';
import 'package:pve_flutter_frontend/widgets/pve_resource_data_card_widget.dart';
import 'package:pve_flutter_frontend/widgets/pve_rrd_chart_widget.dart';
import 'package:pve_flutter_frontend/widgets/pve_task_log_expansiontile_widget.dart';
import 'dart:math';

import 'package:pve_flutter_frontend/widgets/pve_task_log_widget.dart';

class PveNodeOverview extends StatelessWidget {
  static final routeName = RegExp(r'\/nodes\/(\S+)$');
  final String nodeID;

  Icon getServiceStateIcon(BuildContext context, PveNodeServicesModel s) {
    if (s.state == 'running')
      return Icon(Icons.play_arrow, color: Colors.green[400]);
    else if (s.unitState == 'masked' || s.unitState == 'not-found')
      return Icon(
        Icons.play_disabled,
        color: IconTheme.of(context).color!.withOpacity(0.75),
      );
    else
      return Icon(Icons.stop, color: Theme.of(context).colorScheme.error);
  }

  const PveNodeOverview({Key? key, required this.nodeID}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final nBloc = Provider.of<PveNodeOverviewBloc>(context);
    final tBloc = Provider.of<PveTaskLogBloc>(context);

    return ProxmoxStreamBuilder<PveNodeOverviewBloc, PveNodeOverviewState>(
      bloc: nBloc,
      builder: (context, state) {
        final status = state.status;
        final rrd = state.rrdData.where((e) => e.time != null);
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              //backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text(
                "Node ${nodeID}",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            //backgroundColor: Theme.of(context).colorScheme.primary,
            backgroundColor: Theme.of(context).colorScheme.background,
            body: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  if (rrd.isNotEmpty)
                    Container(
                      height: 200,
                      color: Theme.of(context).colorScheme.primary,
                      child: ScrollConfiguration(
                        behavior: PVEScrollBehavior(),
                        child: PageView.builder(
                          itemCount: 4,
                          itemBuilder: (context, item) {
                            final page = item + 1;
                            final pageIndicator = Text(
                              '$page of 4',
                              style: TextStyle(
                                color: Colors.white54,
                                fontWeight: FontWeight.w500,
                              ),
                            );
                            double? last_cpu = rrd.last.cpu;
                            String last_cpu_text = last_cpu != null
                                ? "${(last_cpu * 100.0).toStringAsFixed(2)} %"
                                : "";
                            return Column(
                              children: [
                                if (item == 0)
                                  Expanded(
                                    child: PveRRDChart(
                                      title:
                                          'CPU (${state.status?.cpuinfo?.cpus ?? '-'})',
                                      subtitle: last_cpu_text,
                                      data: rrd.where((e) => e.cpu != null).map(
                                          (e) => Point(
                                              e.time!.millisecondsSinceEpoch,
                                              e.cpu! * 100.0)),
                                      icon: Icon(Icons.memory),
                                      bottomRight: pageIndicator,
                                      dataRenderer: (data) =>
                                          '${data.toStringAsFixed(2)} %',
                                    ),
                                  ),
                                if (item == 1)
                                  Expanded(
                                    child: PveRRDChart(
                                      title: 'Memory',
                                      subtitle: Renderers.formatSize(
                                          rrd.last.memused ?? 0),
                                      data: rrd.map((e) => Point(
                                          e.time!.millisecondsSinceEpoch,
                                          e.memused!)),
                                      icon: Icon(FontAwesomeIcons.memory),
                                      bottomRight: pageIndicator,
                                      dataRenderer: (data) =>
                                          Renderers.formatSize(data),
                                    ),
                                  ),
                                if (item == 2)
                                  Expanded(
                                    child: PveRRDChart(
                                      title: 'I/O wait',
                                      subtitle:
                                          rrd.last.iowait?.toStringAsFixed(2) ??
                                              '0',
                                      data: rrd.map((e) => Point(
                                          e.time!.millisecondsSinceEpoch,
                                          e.iowait ?? 0)),
                                      icon: Icon(Icons.timer),
                                      bottomRight: pageIndicator,
                                      dataRenderer: (data) =>
                                          data.toStringAsFixed(3),
                                    ),
                                  ),
                                if (item == 3)
                                  Expanded(
                                    child: PveRRDChart(
                                      title: 'Load',
                                      subtitle: rrd.last.loadavg
                                              ?.toStringAsFixed(2) ??
                                          '0',
                                      data: rrd.map((e) => Point(
                                          e.time!.millisecondsSinceEpoch,
                                          e.loadavg!)),
                                      icon: Icon(Icons.show_chart),
                                      bottomRight: pageIndicator,
                                      dataRenderer: (data) =>
                                          data.toStringAsFixed(2),
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ProxmoxStreamBuilder<PveTaskLogBloc, PveTaskLogState>(
                    bloc: tBloc,
                    builder: (context, taskState) {
                      if (taskState.tasks != null &&
                          taskState.tasks.isNotEmpty) {
                        return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: PveTaskExpansionTile(
                            task: taskState.tasks.first,
                            showMorePage: Provider<PveTaskLogBloc>(
                              create: (context) => PveTaskLogBloc(
                                apiClient: tBloc.apiClient,
                                init: PveTaskLogState.init(nodeID),
                              )..events.add(LoadTasks()),
                              dispose: (context, bloc) => bloc.dispose(),
                              child: PveTaskLog(),
                            ),
                          ),
                        );
                      }
                      return Container();
                    },
                  ),
                  Container(
                    height: 130,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          ActionCard(
                            icon: Icon(
                              Icons.queue_play_next,
                              size: 55,
                              color: Colors.white24,
                            ),
                            title: 'Console',
                            onTap: () => showConsoleMenuBottomSheet(
                                context, nBloc.apiClient, null, nodeID, 'node'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  PveResourceDataCardWidget(
                    expandable: false,
                    showTitleTrailing: true,
                    title: Text(
                      'Summary',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    titleTrailing: Text(Renderers.renderDuration(
                        Duration(seconds: status?.uptime ?? 0))),
                    subtitle: Text(status?.pveversion ?? ''),
                    children: [
                      ListTile(
                        dense: true,
                        title: Text(status?.kversion ?? 'unkown'),
                        subtitle: Text('Kernel'),
                      ),
                      if (status?.cpuinfo != null)
                        ListTile(
                          dense: true,
                          title: Text(
                              '${status!.cpuinfo.cpus} x ${status.cpuinfo.model}'),
                          subtitle: Text(
                              'CPU Information (Socket: ${status.cpuinfo.sockets})'),
                        ),
                      if (status?.ksm?.shared ?? false)
                        CheckboxListTile(
                          dense: true,
                          value: status?.ksm?.shared ?? false,
                          title: Text('Kernel same-page merging (KSM)',
                              style: TextStyle(color: Colors.black)),
                          onChanged: null,
                        ),
                      if (status?.rootfs != null) ...[
                        Divider(
                          indent: 10,
                          endIndent: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            title: Text('HD space (root)'),
                            subtitle: ProxmoxCapacityIndicator(
                              icon: Icon(
                                FontAwesomeIcons.solidHdd,
                                color: Colors.blueGrey[300],
                              ),
                              usedValue:
                                  Renderers.formatSize(status!.rootfs.used),
                              totalValue:
                                  Renderers.formatSize(status.rootfs.total),
                              usedPercent:
                                  (status.rootfs.used) / (status.rootfs.total),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  PveResourceDataCardWidget(
                    expandable: true,
                    showTitleTrailing: !state.allServicesRunning,
                    titleTrailing: Icon(Icons.warning),
                    title: Text(
                      'Services',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        if (state.allServicesRunning) Text('All running'),
                        if (!state.allServicesRunning)
                          Text('One or more not running'),
                        Divider(),
                      ],
                    ),
                    children: state.services
                        .map(
                          (s) => ListTile(
                            dense: true,
                            title: Text('${s.name}'),
                            subtitle: Text('${s.desc}'),
                            trailing: getServiceStateIcon(context, s),
                          ),
                        )
                        .toList()
                      ..sort((a, b) => (a.title as Text)
                          .data!
                          .compareTo((b.title as Text).data!)),
                  ),
                  PveResourceDataCardWidget(
                    expandable: true,
                    showTitleTrailing: state.updates.isNotEmpty,
                    titleTrailing: Icon(Icons.info_outline),
                    title: Text(
                      'Updates',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        if (state.updates.isEmpty) Text('No updates available'),
                        if (state.updates.isNotEmpty)
                          Text(
                              '${state.updates.length} packages are ready to update'),
                        Divider(),
                      ],
                    ),
                    children: state.updates
                        .map(
                          (s) => ListTile(
                            dense: true,
                            title: Text('${s.title}'),
                            subtitle: Text(
                                '${s.package}: ${s.oldVersion ?? ''} -> ${s.version}'),
                            trailing: IconButton(
                              icon: Icon(
                                Icons.info,
                              ),
                              onPressed: () => showDialog(
                                context: context,
                                builder: (context) => SimpleDialog(
                                  title: Text('Description'),
                                  contentPadding: EdgeInsets.all(24),
                                  children: <Widget>[
                                    Text(
                                      s.description!,
                                      style: TextStyle(fontSize: 12),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList()
                      ..sort((a, b) => (a.title as Text)
                          .data!
                          .compareTo((b.title as Text).data!)),
                  ),
                  PveResourceDataCardWidget(
                    expandable: false,
                    title: Text(
                      'Disks',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    showTitleTrailing: !state.allDisksHealthy,
                    titleTrailing: Icon(Icons.warning),
                    subtitle: state.allDisksHealthy
                        ? Text('No health issues')
                        : Text('Check disks, health error indicated!'),
                    children: state.disks
                        .map(
                          (d) => ListTile(
                            dense: true,
                            leading: Icon(FontAwesomeIcons.solidHdd,
                                color: state.isDiskHealthy(d)
                                    ? Colors.grey
                                    : Colors.red),
                            title:
                                Text('${d.type!.toUpperCase()}: ${d.devPath}'),
                            subtitle: Text(
                                'Usage: ${d.used} ${Renderers.formatSize(d.size ?? 0)}'),
                            trailing: IconButton(
                              icon: Icon(
                                Icons.info,
                              ),
                              onPressed: () => showDialog(
                                context: context,
                                builder: (context) => SimpleDialog(
                                  title: Text('Details'),
                                  contentPadding: EdgeInsets.all(24),
                                  children: <Widget>[
                                    ListTile(
                                      title: Text("Device"),
                                      subtitle: Text(d.devPath!),
                                    ),
                                    ListTile(
                                      title: Text("Type"),
                                      subtitle: Text(d.type!),
                                    ),
                                    ListTile(
                                      title: Text("Usage"),
                                      subtitle: Text(d.used!),
                                    ),
                                    ListTile(
                                      title: Text("GPT"),
                                      subtitle: Text(d.gpt.toString()),
                                    ),
                                    ListTile(
                                      title: Text("Model"),
                                      subtitle: Text(d.model!),
                                    ),
                                    ListTile(
                                      title: Text("Serial"),
                                      subtitle: Text(d.serial!),
                                    ),
                                    ListTile(
                                      title: Text("S.M.A.R.T"),
                                      subtitle: Text(d.health!),
                                    ),
                                    ListTile(
                                      title: Text("Wearout"),
                                      subtitle: Text(d.wearout_percentage),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList()
                      ..sort((a, b) => (a.title as Text)
                          .data!
                          .compareTo((b.title as Text).data!)),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
