import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pve_flutter_frontend/bloc/pve_node_overview_bloc.dart';
import 'package:pve_flutter_frontend/bloc/pve_task_log_bloc.dart';
import 'package:pve_flutter_frontend/states/pve_node_overview_state.dart';
import 'package:pve_flutter_frontend/states/pve_task_log_state.dart';
import 'package:pve_flutter_frontend/utils/renderers.dart';
import 'package:pve_flutter_frontend/widgets/proxmox_capacity_indicator.dart';
import 'package:pve_flutter_frontend/widgets/proxmox_line_chart.dart';
import 'package:pve_flutter_frontend/widgets/proxmox_stream_builder_widget.dart';
import 'package:pve_flutter_frontend/widgets/pve_task_log_expansiontile_widget.dart';
import 'dart:math';

import 'package:pve_flutter_frontend/widgets/pve_task_log_widget.dart';

class PveNodeOverview extends StatelessWidget {
  static final routeName = RegExp(r'\/nodes\/(\S+)$');
  final String nodeID;

  const PveNodeOverview({Key key, this.nodeID}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final nBloc = Provider.of<PveNodeOverviewBloc>(context);
    final width = MediaQuery.of(context).size.width;
    final tBloc = Provider.of<PveTaskLogBloc>(context);

    return ProxmoxStreamBuilder<PveNodeOverviewBloc, PveNodeOverviewState>(
      bloc: nBloc,
      builder: (context, state) {
        final status = state.status;
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            backgroundColor: Color(0xFF00617F),
            body: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          width: width * 0.6,
                          child: Text(
                            nodeID,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 25),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (state.rrdData.isNotEmpty)
                    Container(
                      height: 200,
                      child: PageView.builder(
                          itemCount: 3,
                          itemBuilder: (context, item) {
                            if (item == 0) {
                              return PveRRDChart(
                                title:
                                    'CPU (${state.status?.cpuinfo?.cpus ?? '-'})',
                                subtitle: (state.rrdData.last?.cpu ?? 0 * 100)
                                        .toStringAsFixed(2) +
                                    "%",
                                data: state.rrdData.map((e) => Point(
                                    e.time.millisecondsSinceEpoch, e.cpu)),
                                icon: Icon(Icons.memory),
                              );
                            }
                            if (item == 1) {
                              return PveRRDChart(
                                title: 'I/O wait',
                                subtitle:
                                    (state.rrdData.last?.iowait ?? 0 * 100)
                                            .toStringAsFixed(2) +
                                        "%",
                                data: state.rrdData.map((e) => Point(
                                    e.time.millisecondsSinceEpoch, e.iowait)),
                                icon: Icon(Icons.timer),
                              );
                            }
                            if (item == 2) {
                              return PveRRDChart(
                                title: 'Load',
                                subtitle:
                                    (state.rrdData.last?.loadavg ?? 0 * 100)
                                            .toStringAsFixed(2) +
                                        "%",
                                data: state.rrdData.map((e) => Point(
                                    e.time.millisecondsSinceEpoch, e.loadavg)),
                                icon: Icon(Icons.show_chart),
                              );
                            }
                          }),
                    ),
                  ProxmoxStreamBuilder<PveTaskLogBloc, PveTaskLogState>(
                    bloc: tBloc,
                    builder: (context, taskState) {
                      if (taskState.tasks != null &&
                          taskState.tasks.isNotEmpty) {
                        return Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: PveTaskExpansionTile(
                            infoColor: Colors.white,
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  'Summary',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                Text(Renderers.renderDuration(
                                    Duration(seconds: status?.uptime ?? 0))),
                              ],
                            ),
                            subtitle: Text(status?.pveversion ?? 'unkown'),
                          ),
                          Divider(
                            indent: 10,
                            endIndent: 10,
                          ),
                          ListTile(
                            dense: true,
                            title: Text(status?.kversion ?? 'unkown'),
                            subtitle: Text('Kernel'),
                          ),
                          if (status?.cpuinfo != null)
                            ListTile(
                              dense: true,
                              title: Text(
                                  '${status.cpuinfo.cpus} x ${status.cpuinfo.model}'),
                              subtitle: Text(
                                  'CPU Information (Socket: ${status.cpuinfo.sockets})'),
                            ),
                          CheckboxListTile(
                            dense: true,
                            value: status?.ksm?.shared ?? false,
                            title: Text('Kernel same-page merging (KSM)'),
                            onChanged: (v) {},
                          ),
                          if (status?.rootfs != null) ...[
                            Divider(
                              indent: 10,
                              endIndent: 10,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: ListTile(
                                title: Text('HD space (root)'),
                                subtitle: ProxmoxCapacityIndicator(
                                  icon: Icon(
                                    FontAwesomeIcons.solidHdd,
                                    color: Colors.blueGrey[300],
                                  ),
                                  usedValue: Renderers.formatSize(
                                      status.rootfs.used ?? 0),
                                  totalValue: Renderers.formatSize(
                                      status.rootfs.total ?? 0),
                                  usedPercent: (status.rootfs.used ?? 0.0) /
                                      (status.rootfs.total ?? 100.0),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            ExpansionTile(
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'Services',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  if (!state.allServicesRunning)
                                    Icon(Icons.warning)
                                ],
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  if (state.allServicesRunning)
                                    Text('All running'),
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
                                      trailing: s.state != 'running'
                                          ? Icon(Icons.stop)
                                          : Icon(Icons.play_arrow),
                                    ),
                                  )
                                  .toList()
                                    ..sort((a, b) => (a.title as Text)
                                        .data
                                        .compareTo((b.title as Text).data)),
                            ),
                          ],
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            ExpansionTile(
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'Updates',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  if (state.updates?.isNotEmpty ?? false)
                                    Icon(Icons.info_outline)
                                ],
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  if (state.updates.isEmpty)
                                    Text('No updates available'),
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
                                          '${s.package}: ${s.oldVersion} -> ${s.oldVersion}'),
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
                                                s.description,
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
                                        .data
                                        .compareTo((b.title as Text).data)),
                            ),
                          ],
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            ListTile(
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'Disks',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  if (!state.allDisksHealthy)
                                    Icon(Icons.warning)
                                ],
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  if (state.allDisksHealthy)
                                    Text('No health issues'),
                                  if (!state.allDisksHealthy)
                                    Text(
                                        'Check disks, health error indicated!'),
                                  Divider(),
                                ],
                              ),
                            ),
                            ...state.disks
                                .map(
                                  (d) => ListTile(
                                    dense: true,
                                    leading: Icon(FontAwesomeIcons.solidHdd),
                                    title: Text(
                                        '${d.type.toUpperCase()}: ${d.devPath}'),
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
                                              subtitle: Text(d.devPath),
                                            ),
                                            ListTile(
                                              title: Text("Type"),
                                              subtitle: Text(d.type),
                                            ),
                                            ListTile(
                                              title: Text("Usage"),
                                              subtitle: Text(d.used),
                                            ),
                                            ListTile(
                                              title: Text("GPT"),
                                              subtitle: Text(d.gpt.toString()),
                                            ),
                                            ListTile(
                                              title: Text("Model"),
                                              subtitle: Text(d.model),
                                            ),
                                            ListTile(
                                              title: Text("Serial"),
                                              subtitle: Text(d.serial),
                                            ),
                                            ListTile(
                                              title: Text("S.M.A.R.T"),
                                              subtitle: Text(d.health),
                                            ),
                                            ListTile(
                                              title: Text("Wearout"),
                                              subtitle: Text(d.wearout),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                                .toList()
                                  ..sort((a, b) => (a.title as Text)
                                      .data
                                      .compareTo((b.title as Text).data)),
                          ],
                        )),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class PveRRDChart extends StatelessWidget {
  final String title;
  final String subtitle;
  final Iterable<Point<num>> data;
  final Widget icon;
  final Color lineColor;

  const PveRRDChart({
    Key key,
    this.title,
    this.subtitle,
    this.data,
    this.icon,
    this.lineColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          leading: icon,
          title: Text(
            title,
            style: TextStyle(
                fontSize: 12,
                color: Colors.white60,
                fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: CustomPaint(
              painter:
                  ProxmoxLineChart(data: data?.toList(), lineColor: lineColor),
            ),
          ),
        ),
      ],
    );
  }
}