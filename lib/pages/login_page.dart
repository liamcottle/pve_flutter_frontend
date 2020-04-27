import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pve_flutter_frontend/bloc/pve_login_bloc.dart';
import 'package:pve_flutter_frontend/states/pve_login_state.dart';
import 'package:pve_flutter_frontend/widgets/proxmox_stream_builder_widget.dart';

import 'package:pve_flutter_frontend/widgets/pve_login_form.dart';
import 'package:pve_flutter_frontend/widgets/pve_login_tfa_form.dart';

class PveLoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final lBloc = Provider.of<PveLoginBloc>(context);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [const Color(0xFF2C3443), const Color(0xFF3A465F)],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 400),
              child: ProxmoxStreamBuilder<PveLoginBloc, PveLoginState>(
                bloc: lBloc,
                builder: (context, state) {
                  if (state.isBlank) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (state.showTfa) {
                    return PveLoginTfaForm();
                  }
                  return PveLoginForm(
                    savedOrigin: state.origin,
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
