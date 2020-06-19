import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pve_flutter_frontend/bloc/pve_task_log_bloc.dart';
import 'package:pve_flutter_frontend/bloc/pve_task_log_viewer_bloc.dart';
import 'package:pve_flutter_frontend/states/pve_task_log_state.dart';
import 'package:pve_flutter_frontend/states/pve_task_log_viewer_state.dart';
import 'package:pve_flutter_frontend/widgets/proxmox_stream_builder_widget.dart';
import 'package:pve_flutter_frontend/widgets/proxmox_stream_listener.dart';
import 'package:pve_flutter_frontend/widgets/pve_task_log_expansiontile_widget.dart';

class PveTaskLog extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  PveTaskLog({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<PveTaskLogBloc>(context);
    return ProxmoxStreamBuilder<PveTaskLogBloc, PveTaskLogState>(
        bloc: bloc,
        builder: (context, state) {
          if (state.tasks != null) {
            return SafeArea(
              child: Scaffold(
                key: _scaffoldKey,
                appBar: AppBar(
                  leading: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  actions: <Widget>[
                    IconButton(
                      icon: Icon(Icons.more_vert),
                      onPressed: () =>
                          _scaffoldKey.currentState.openEndDrawer(),
                    )
                  ],
                ),
                endDrawer: Drawer(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Filters',
                          style: Theme.of(context).textTheme.headline5,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                              labelText: 'by user',
                              filled: true,
                              prefixIcon: Icon(Icons.person)),
                          onFieldSubmitted: (newValue) {
                            bloc.events.add(FilterTasksByUser(newValue));
                            bloc.events.add(LoadTasks());
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                              labelText: 'by type',
                              filled: true,
                              prefixIcon: Icon(Icons.description)),
                          onFieldSubmitted: (newValue) {
                            bloc.events.add(FilterTasksByType(newValue));
                            bloc.events.add(LoadTasks());
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(labelText: 'Source'),
                          value: 'all',
                          icon: Icon(Icons.arrow_downward),
                          iconSize: 24,
                          elevation: 16,
                          onChanged: (String newValue) {
                            bloc.events.add(FilterTasksBySource(newValue));
                            bloc.events.add(LoadTasks());
                          },
                          items: <String>[
                            'all',
                            'active',
                            'archive',
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Container(child: Text(value)),
                            );
                          }).toList(),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        FormField(
                          builder: (FormFieldState<bool> formFieldState) => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text("Only errors"),
                              Checkbox(
                                value: state.onlyErrors,
                                onChanged: (value) {
                                  formFieldState.didChange(value);
                                  bloc.events.add(FilterTasksByError());
                                  bloc.events.add(LoadTasks());
                                },
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                body: NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scrollInfo) {
                    if (scrollInfo.metrics.pixels >=
                        (0.9 * scrollInfo.metrics.maxScrollExtent)) {
                      if (!state.isLoading) {
                        bloc.events.add(LoadMoreTasks());
                      }
                    }
                    return false;
                  },
                  child: state.tasks.isNotEmpty
                      ? ListView.builder(
                          itemCount: state.tasks.length,
                          itemBuilder: (context, index) => PveTaskExpansionTile(
                            task: state.tasks[index],
                          ),
                        )
                      : Center(
                          child: Text("No tasks found"),
                        ),
                ),
              ),
            );
          }

          return Container();
        });
  }
}

class PveTaskLogScrollView extends StatefulWidget {
  final Widget icon;
  final Widget jobTitle;

  const PveTaskLogScrollView({
    Key key,
    this.icon,
    this.jobTitle,
  }) : super(key: key);
  @override
  _PveTaskLogScrollViewState createState() => _PveTaskLogScrollViewState();
}

class _PveTaskLogScrollViewState extends State<PveTaskLogScrollView> {
  ScrollController _scrollController = new ScrollController();
  @override
  void initState() {
    super.initState();
    if (mounted) {
      _scrollToBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamListener<PveTaskLogViewerState>(
      stream: Provider.of<PveTaskLogViewerBloc>(context).state.distinct(),
      onStateChange: (newState) {
        if (_scrollController.hasClients) {
          _scrollToBottom();
        }
      },
      child: ProxmoxStreamBuilder<PveTaskLogViewerBloc, PveTaskLogViewerState>(
          bloc: Provider.of<PveTaskLogViewerBloc>(context),
          builder: (context, state) {
            var indicatorColor = Colors.teal.shade500;
            var statusChipColor = Colors.teal.shade100;
            if (state.status?.failed ?? false) {
              indicatorColor = Colors.red;
              statusChipColor = Colors.red.shade100;
            }
            return Container(
              height: MediaQuery.of(context).size.height * 0.5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  if (state.isBlank)
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text("Loading log data.."),
                      ),
                    ),
                  if (!state.isBlank) ...[
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          width: 40,
                          height: 3,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    if (state.status != null)
                      ListTile(
                        leading: widget.icon,
                        title: AnimatedDefaultTextStyle(
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1
                              .copyWith(fontWeight: FontWeight.bold),
                          duration: kThemeChangeDuration,
                          child: widget.jobTitle ?? const SizedBox(),
                        ),
                        trailing: Chip(
                          label: Text(
                            state.status.status.name,
                            style: TextStyle(color: indicatorColor),
                          ),
                          backgroundColor: statusChipColor,
                        ),
                      ),
                    Divider(),
                    if (state.log != null)
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: ListView.builder(
                            controller: _scrollController,
                            itemCount: state.log.lines.length,
                            itemBuilder: (context, index) {
                              final isLast =
                                  index == state.log.lines.length - 1;
                              final errorLine = state.log.lines[index].lineText
                                  .contains('ERROR');
                              return Card(
                                color: isLast || errorLine
                                    ? indicatorColor
                                    : Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    state.log.lines[index].lineText,
                                    style: TextStyle(
                                      color: isLast || errorLine
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                  ]
                ],
              ),
            );
          }),
    );
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 50), curve: Curves.ease);
    }
  }
}
