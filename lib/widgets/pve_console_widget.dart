import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pve_flutter_frontend/utils/utils.dart'
    if (dart.library.html) 'package:pve_flutter_frontend/utils/utils_web.dart';

class PveConsoleWidget extends StatelessWidget {
  static const routeName = '/console';
  final String vmid;
  final String nodeid;
  const PveConsoleWidget({Key key, this.vmid, @required this.nodeid})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    //TODO change this when there's a more official way to determine web e.g. Platform.isWeb or similar
    if (kIsWeb) {
      registerConsoleIframe(nodeid);
      return Container(
          child: HtmlElementView(
        viewType: 'console-html',
      ));
    } else {
      return Container();
    }
  }
}
