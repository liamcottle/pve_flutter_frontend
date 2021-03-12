import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pve_flutter_frontend/states/pve_base_state.dart';

import 'package:pve_flutter_frontend/bloc/proxmox_base_bloc.dart';
import 'package:pve_flutter_frontend/widgets/proxmox_stream_listener.dart';

typedef AsyncWidgetBuilder<S> = Widget Function(BuildContext context, S state);

abstract class ProxmoxBaseStreamBuilder<B extends ProxmoxBaseBloc<dynamic, S>,
    S extends PveBaseState> extends StatefulWidget {
  final B bloc;
  final bool errorHandler;
  const ProxmoxBaseStreamBuilder({Key key, this.bloc, this.errorHandler})
      : super(key: key);

  Widget build(BuildContext context, S state);

  @override
  _ProxmoxBaseStreamBuilderState createState() =>
      _ProxmoxBaseStreamBuilderState();
}

class _ProxmoxBaseStreamBuilderState<B extends ProxmoxBaseBloc<dynamic, S>,
    S extends PveBaseState> extends State<ProxmoxBaseStreamBuilder<B, S>> {
  @override
  Widget build(BuildContext context) {
    return StreamListener<S>(
      stream: widget.bloc.state,
      onStateChange: (newState) {
        if (newState.isFailure && widget.errorHandler)
          ScaffoldMessenger.of(context)?.showSnackBar(
                SnackBar(
                  content: Text(
                    newState.errorMessage ?? "Error",
                    style: ThemeData.dark().textTheme.button,
                  ),
                  backgroundColor: ThemeData.dark().errorColor,
                ),
              ) ??
              showDialog<String>(
                context: context,
                builder: (BuildContext context) {
                  return SimpleDialog(
                    contentPadding:
                        const EdgeInsets.fromLTRB(24.0, 12.0, 24.0, 16.0),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Error'),
                        Icon(Icons.warning),
                      ],
                    ),
                    children: [
                      Text(newState.errorMessage),
                    ],
                  );
                },
              );
      },
      child: StreamBuilder<S>(
          stream: widget.bloc.state,
          initialData: widget.bloc.initialState,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return widget.build(context, snapshot.data);
            }
            return Container();
          }),
    );
  }
}

class ProxmoxStreamBuilder<B extends ProxmoxBaseBloc<dynamic, S>,
    S extends PveBaseState> extends ProxmoxBaseStreamBuilder<B, S> {
  final AsyncWidgetBuilder<S> builder;

  const ProxmoxStreamBuilder({
    Key key,
    @required this.builder,
    B bloc,
    bool errorHandler = true,
  })  : assert(builder != null),
        super(key: key, bloc: bloc, errorHandler: errorHandler);

  @override
  Widget build(BuildContext context, S state) => builder(context, state);
}
