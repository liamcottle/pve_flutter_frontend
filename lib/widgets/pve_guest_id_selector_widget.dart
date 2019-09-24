import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:pve_flutter_frontend/bloc/pve_guest_id_selector_bloc.dart';
import 'package:pve_flutter_frontend/events/pve_guest_id_selector_events.dart';
import 'package:pve_flutter_frontend/states/pve_guest_id_selector_states.dart';

class PveGuestIdSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _pveGuestIdSelectorBloc =
        Provider.of<PveGuestIdSelectorBloc>(context);

    return StreamBuilder<PveGuestIdSelectorState>(
        stream: _pveGuestIdSelectorBloc.state,
        builder: (context, snapshot) {
          print("build");
          if (snapshot.hasData) {
            final state = snapshot.data;
            return TextFormField(
              decoration:
                  InputDecoration(labelText: 'VM ID', errorText: state.error),
              initialValue: state.id,
              keyboardType: TextInputType.number,
              inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
              onChanged: (text) {
                _pveGuestIdSelectorBloc.events.add(ValidateInput(text));
              },
            );
          }
          return Container();
        });
  }
}
