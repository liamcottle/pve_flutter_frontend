import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pve_flutter_frontend/bloc/pve_task_log_bloc.dart';
import 'package:pve_flutter_frontend/states/pve_task_log_state.dart';
import 'package:pve_flutter_frontend/widgets/proxmox_stream_builder_widget.dart';
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
