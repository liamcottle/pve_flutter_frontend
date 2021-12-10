import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:proxmox_dart_api_client/proxmox_dart_api_client.dart';
import 'package:pve_flutter_frontend/bloc/pve_task_log_bloc.dart';
import 'package:pve_flutter_frontend/utils/renderers.dart';
import 'package:pve_flutter_frontend/utils/utils.dart';

class PveTaskExpansionTile extends StatefulWidget {
  final Color errorColor;
  final Color headerColor;
  final Color headerColorExpanded;
  final Widget? showMorePage;
  const PveTaskExpansionTile({
    Key? key,
    required this.task,
    this.showMorePage,
    this.errorColor = Colors.orange,
    this.headerColor = Colors.black,
    this.headerColorExpanded = Colors.blue,
  }) : super(key: key);

  final PveClusterTasksModel task;

  @override
  _PveTaskExpansionTileState createState() => _PveTaskExpansionTileState();
}

class _PveTaskExpansionTileState extends State<PveTaskExpansionTile> {
  late bool isExpanded;
  @override
  void initState() {
    super.initState();
    isExpanded = false;
  }

  @override
  Widget build(BuildContext context) {
    final hasError =
        widget.task.status != 'RUNNING' && widget.task.status != "OK";
    final isFinished = widget.task.endTime != null;
    final taskLogBloc = Provider.of<PveTaskLogBloc>(context);
    var duration;
    if (isFinished) {
      duration = widget.task.endTime!.difference(widget.task.startTime);
    }
    final headerColor =
        isExpanded ? widget.headerColorExpanded : widget.headerColor;
    return ExpansionTile(
      onExpansionChanged: (value) {
        setState(() {
          isExpanded = value;
        });
      },
      backgroundColor: Colors.white,
      key: PageStorageKey<PveClusterTasksModel>(widget.task),
      leading: Icon(
        hasError ? Icons.warning : Icons.info,
        color: hasError ? widget.errorColor : headerColor,
      ),
      title: Text(
        widget.task.type,
        style: TextStyle(color: headerColor),
      ),
      subtitle: isFinished
          ? Text(DateFormat.Md().add_Hms().format(widget.task.endTime!),
              style: TextStyle(color: headerColor))
          : LinearProgressIndicator(
              backgroundColor: headerColor.withOpacity(0.5),
              valueColor: AlwaysStoppedAnimation<Color>(headerColor),
            ),
      trailing: Icon(
        Icons.expand_more,
        color: headerColor,
      ),
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.person),
          title: Text(widget.task.user),
          subtitle: Text('User'),
        ),
        ListTile(
          leading: Icon(Icons.timer),
          title: Text(
            DateFormat.Md().add_Hms().format(widget.task.startTime),
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
          title: Text("${widget.task.status}"),
          dense: true,
          subtitle: Text('Shortlog'),
        ),
        ButtonBar(
          children: <Widget>[
            if (widget.showMorePage != null)
              FlatButton(
                onPressed: () => Navigator.of(context).push(
                    _createTaskLogRoute(taskLogBloc, widget.showMorePage)),
                child: Text('More Tasks'),
              ),
            FlatButton(
              onPressed: () => showTaskLogBottomSheet(context,
                  taskLogBloc.apiClient, widget.task.node, widget.task.upid),
              child: Text(
                'Full Log',
              ),
            )
          ],
        )
      ],
    );
  }

  Route _createTaskLogRoute(PveTaskLogBloc bloc, Widget? page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page!,
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
