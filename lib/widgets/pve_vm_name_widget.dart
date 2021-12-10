import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/streams.dart' show ValueStreamExtensions;
import 'package:pve_flutter_frontend/bloc/pve_vm_name_bloc.dart';

class PveVmNameWidget extends StatelessWidget {
  final String labelText;

  const PveVmNameWidget({Key? key, this.labelText = 'Name'}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final vBloc = Provider.of<PveVmNameBloc>(context);
    return StreamBuilder<PveVmNameState>(
        stream: vBloc.state,
        initialData: vBloc.state.value,
        builder: (context, snapshot) {
          final state = snapshot.data;

          return TextFormField(
            key: state?.value != null ? null : ValueKey(1),
            decoration: InputDecoration(
              labelText: labelText,
              helperText: ' ',
            ),
            initialValue: state?.value,
            onChanged: (text) => vBloc.events.add(OnChange(text)),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (_) {
              return state?.errorText;
            },
          );
        });
  }
}
