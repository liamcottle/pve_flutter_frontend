import 'package:flutter/material.dart';
import 'package:pve_flutter_frontend/bloc/pve_task_log_bloc.dart';
import 'package:pve_flutter_frontend/events/pve_task_log_events.dart';
import 'package:pve_flutter_frontend/states/pve_task_log_states.dart';

class PVETaskLog extends StatefulWidget {
  final PveTaskLogBloc bloc;

  const PVETaskLog({Key key, this.bloc}) : super(key: key);

  @override
  _PVETaskLogState createState() => _PVETaskLogState();
}

class _PVETaskLogState extends State<PVETaskLog> {
  PveTaskLogBloc get _taskBloc => widget.bloc;

  @override
  void initState() {
    super.initState();

    _taskBloc.events.add(LoadRecentTasks());
  }

  @override
  void dispose() {
    _taskBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: Icon(Icons.close),
                tooltip: 'Close log',
                onPressed: () {
                  // this works, because showBottomSheet creates a LocalHistoryEntry
                  // the same behavior is triggerd by the browser back button
                  Navigator.pop(context);
                },
              ),
            ),
            Row(
              children: <Widget>[],
            ),
            Expanded(
              child: StreamBuilder<PVETaskLogState>(
                stream: _taskBloc?.state,
                builder: (BuildContext context,
                    AsyncSnapshot<PVETaskLogState> snapshot) {
                  if (snapshot.hasError)
                    return Text('Error: ${snapshot.error}');
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      return Center(child: CircularProgressIndicator());
                    case ConnectionState.waiting:
                      return Center(child: CircularProgressIndicator());
                    case ConnectionState.active:
                      if (snapshot.data is LoadedRecentTasks) {
                        final tasks =
                            (snapshot.data as LoadedRecentTasks).tasks;
                        return Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Container(
                                  width: 150,
                                  child: Text("Start time"),
                                ),
                                Container(
                                  width: 150,
                                  child: Text("End time"),
                                ),
                                Expanded(
                                  child: Text("Node"),
                                ),
                                Container(
                                  width: 150,
                                  child: Text("User"),
                                ),
                                Container(
                                  width: 150,
                                  child: Text("Status"),
                                ),
                              ],
                            ),
                            Divider(),
                            Expanded(
                              child: ListView.builder(
                                  itemCount: tasks.length,
                                  itemBuilder: (context, index) => Row(
                                        children: <Widget>[
                                          Container(
                                            width: 150,
                                            child:
                                                tasks[index].startTime != null
                                                    ? Text(
                                                        tasks[index]
                                                            .startTime
                                                            .toIso8601String(),
                                                      )
                                                    : Text(""),
                                          ),
                                          Container(
                                            width: 150,
                                            child: Center(
                                              child: tasks[index].endTime !=
                                                      null
                                                  ? Text(tasks[index]
                                                      .endTime
                                                      ?.toIso8601String())
                                                  : CircularProgressIndicator(),
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(tasks[index].node),
                                          ),
                                          Container(
                                            width: 150,
                                            child: Text(tasks[index].user),
                                          ),
                                          Container(
                                            width: 150,
                                            child: PveTaskLogStatusWidget(
                                                status: tasks[index].status),
                                          ),
                                        ],
                                      )),
                            )
                          ],
                        );
                      }

                      if (snapshot.data is NoTaskLogsAvailable) {
                        return Center(
                          child: Text("No task logs available"),
                        );
                      }
                      return Text('\$${snapshot.data}');
                    case ConnectionState.done:
                      return Text('Connection (closed)');
                  }
                  return null; // unreachable
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PveTaskLogStatusWidget extends StatelessWidget {
  final String status;

  const PveTaskLogStatusWidget({Key key, this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (status != null) {
      switch (status) {
        case "OK":
          return Chip(
            label: Text(
              "ok",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.lightGreenAccent,
            padding: EdgeInsets.fromLTRB(20, 3, 20, 3),
          );

        default:
          return Chip(
            label: Text("error"),
            backgroundColor: Colors.red,
            padding: EdgeInsets.fromLTRB(20, 3, 20, 3),
          );
      }
    } else {
      return Chip(
        label: Text("running"),
      );
    }
  }
}
