import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:proxmox_dart_api_client/proxmox_dart_api_client.dart';
import 'package:pve_flutter_frontend/bloc/pve_task_log_bloc.dart';
import 'package:pve_flutter_frontend/bloc/pve_task_log_viewer_bloc.dart';
import 'package:pve_flutter_frontend/states/pve_task_log_viewer_state.dart';
import 'package:pve_flutter_frontend/widgets/proxmox_stream_builder_widget.dart';

class PveTaskExpansionTile extends StatelessWidget {
  final Color errorColor;
  final Color infoColor;
  final Widget showMorePage;
  const PveTaskExpansionTile({
    Key key,
    @required this.task,
    this.showMorePage,
    this.errorColor = Colors.orange,
    this.infoColor = Colors.blue,
  }) : super(key: key);

  final PveClusterTasksModel task;

  @override
  Widget build(BuildContext context) {
    final hasError = task.status != 'RUNNING' && task.status != "OK";
    final isFinished = task.endTime != null;
    final taskLogBloc = Provider.of<PveTaskLogBloc>(context);
    return ExpansionTile(
      backgroundColor: Colors.white,
      key: PageStorageKey<PveClusterTasksModel>(task),
      leading: Icon(
        hasError ? Icons.warning : Icons.info,
        color: hasError ? errorColor : infoColor,
      ),
      title: Text(task.type),
      subtitle: isFinished
          ? Text(DateFormat.Md().add_Hms().format(task.endTime))
          : LinearProgressIndicator(),
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.person),
          title: Text(task.user),
        ),
        ListTile(
          leading: Icon(Icons.timer),
          title: Text(
            DateFormat.Md().add_Hms().format(task.startTime),
          ),
        ),
        ListTile(
          leading: Icon(Icons.description),
          title: Text("${task.status}"),
          dense: true,
        ),
        ButtonBar(
          children: <Widget>[
            if (showMorePage != null)
              FlatButton(
                onPressed: () => Navigator.of(context)
                    .push(_createTaskLogRoute(taskLogBloc, showMorePage)),
                child: Text('More Tasks'),
              ),
            //TODO enhance UX
            FlatButton(
              onPressed: () => showModalBottomSheet(
                  context: context,
                  builder: (context) => Provider(
                        create: (context) => PveTaskLogViewerBloc(
                          apiClient: taskLogBloc.apiClient,
                          init: PveTaskLogViewerState.init(
                            task.node,
                            upid: task.upid,
                          ),
                        ),
                        child: Builder(
                          builder: (context) => ProxmoxStreamBuilder<
                                  PveTaskLogViewerBloc, PveTaskLogViewerState>(
                              bloc: Provider.of<PveTaskLogViewerBloc>(context),
                              builder: (context, state) {
                                if (state.isBlank) {
                                  return Center(
                                      child: Text("Waiting for data.."));
                                }

                                return SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      if (state.status != null)
                                        Text(state.status.status.name),
                                      if (state.log != null)
                                        ...state.log.lines
                                            .map((l) => Text(l.lineText))
                                    ],
                                  ),
                                );
                              }),
                        ),
                      )),
              child: Text('Full Log'),
            )
          ],
        )
      ],
    );
  }

  Route _createTaskLogRoute(PveTaskLogBloc bloc, Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.fastOutSlowIn,
            ),
          ),
          child: child,
        );
      },
    );
  }
}
