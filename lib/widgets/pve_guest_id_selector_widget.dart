import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/streams.dart' show ValueStreamExtensions;
import 'package:pve_flutter_frontend/bloc/pve_guest_id_selector_bloc.dart';
import 'package:pve_flutter_frontend/states/proxmox_form_field_state.dart';

class PveGuestIdSelector extends StatelessWidget {
  final String labelText;

  PveGuestIdSelector({
    Key key,
    this.labelText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _pveGuestIdSelectorBloc =
        Provider.of<PveGuestIdSelectorBloc>(context);
    return StreamBuilder<PveFormFieldState>(
        stream: _pveGuestIdSelectorBloc.state,
        initialData: _pveGuestIdSelectorBloc.state.value,
        builder: (context, snapshot) {
          final state = snapshot.data;

          return TextFormField(
            // make sure a new internal state is created if the
            // first build has no data
            key: state.value != null ? null : ValueKey(1),
            decoration: InputDecoration(labelText: labelText, helperText: ' '),
            initialValue: state?.value,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onChanged: (text) {
              _pveGuestIdSelectorBloc.events.add(OnChanged(text));
            },
            validator: (_) {
              return state?.errorText;
            },
          );
        });
  }
}
