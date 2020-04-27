import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pve_flutter_frontend/bloc/pve_authentication_bloc.dart';
import 'package:pve_flutter_frontend/bloc/pve_login_bloc.dart';
import 'package:pve_flutter_frontend/events/pve_login_events.dart';
import 'package:pve_flutter_frontend/states/pve_login_state.dart';
import 'package:pve_flutter_frontend/widgets/proxmox_stream_builder_widget.dart';
import 'package:pve_flutter_frontend/widgets/proxmox_stream_listener.dart';

class PveLoginTfaForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final aBloc = Provider.of<PveAuthenticationBloc>(context);
    final lBloc = Provider.of<PveLoginBloc>(context);
    return StreamListener(
      stream: lBloc.state.where((state) => state.isSuccess),
      onStateChange: (newState) {
        aBloc.events.add(LoggedIn(newState.apiClient));
      },
      child: StreamListener(
        stream: aBloc.state.where((state) => state is Authenticated),
        onStateChange: (newState) =>
            Navigator.of(context).pushReplacementNamed('/'),
        child: ProxmoxStreamBuilder<PveLoginBloc, PveLoginState>(
            errorHandler: false,
            bloc: lBloc,
            builder: (context, state) {
              return Theme(
                data: ThemeData.dark().copyWith(accentColor: Color(0xFFE47225)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 100.0, 0, 30.0),
                      child: Icon(
                        Icons.lock,
                        size: 48,
                      ),
                    ),
                    Text(
                      'Verify',
                      style: TextStyle(
                          fontSize: 36,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Check your second factor provider',
                      style: TextStyle(
                          color: Colors.white38, fontWeight: FontWeight.bold),
                    ),
                    if (!state.isLoading)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 50.0, 0, 8.0),
                        child: TextField(
                          decoration: InputDecoration(labelText: 'Code'),
                          onSubmitted: (value) =>
                              lBloc.events.add(TfaCodeSubmitted(value)),
                        ),
                      ),
                    if (state.isLoading)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 50.0, 0, 8.0),
                        child: CircularProgressIndicator(),
                      )
                  ],
                ),
              );
            }),
      ),
    );
  }
}
