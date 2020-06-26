import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:proxmox_dart_api_client/proxmox_dart_api_client.dart';
import 'package:pve_flutter_frontend/bloc/pve_task_log_bloc.dart';
import 'package:pve_flutter_frontend/utils/renderers.dart';
import 'package:pve_flutter_frontend/utils/utils.dart';

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
    var duration;
    if (isFinished) {
      duration = task.endTime.difference(task.startTime);
    }
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
          subtitle: Text('User'),
        ),
        ListTile(
          leading: Icon(Icons.timer),
          title: Text(
            DateFormat.Md().add_Hms().format(task.startTime),
          ),
          subtitle: Text('Start time'),
        ),
        if (duration != null)
          ListTile(
            leading: Icon(Icons.timelapse),
            title: Text(
              Renderers.renderDuration(duration),
            ),
            subtitle: Text('Duration'),
          ),
        ListTile(
          leading: Icon(Icons.description),
          title: Text("${task.status}"),
          dense: true,
          subtitle: Text('Shortlog'),
        ),
        ButtonBar(
          children: <Widget>[
            if (showMorePage != null)
              FlatButton(
                onPressed: () => Navigator.of(context)
                    .push(_createTaskLogRoute(taskLogBloc, showMorePage)),
                child: Text('More Tasks'),
              ),
            FlatButton(
              onPressed: () => showTaskLogBottomSheet(
                  context, taskLogBloc.apiClient, task.node, task.upid),
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
