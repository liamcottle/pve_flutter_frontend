import 'package:flutter/material.dart';
import 'package:pve_flutter_frontend/utils/utils.dart';

class PveHelpIconButton extends StatelessWidget {
  final String docPath;

  const PveHelpIconButton({Key key, this.docPath}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.help),
      tooltip: "Documentation",
      onPressed: () {
        try {
          launchDocURL('/pve-docs/$docPath');
        } catch (e) {
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text(
              "Could not open Docs",
              style: ThemeData.dark().textTheme.button,
            ),
            backgroundColor: ThemeData.dark().errorColor,
            behavior: SnackBarBehavior.floating,
          ));
        }
      },
    );
  }
}
