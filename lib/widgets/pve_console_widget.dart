import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:html';

class PveConsoleWidget extends StatelessWidget {
  static const routeName = '/console';
  final String vmid;
  final String nodeid;
  const PveConsoleWidget({Key key, this.vmid, @required this.nodeid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //TODO move to plugin or platform specific file
    // analyzer
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      'console-html',
      (int viewId) => IFrameElement()
        ..width = '640'
        ..height = '360'
        ..src = 'http://localhost/?console=shell&node=$nodeid&resize=scale&xtermjs=1'
        ..style.border = 'none');
    return Container(
     child: HtmlElementView(viewType: 'console-html',)
    );
  }
}