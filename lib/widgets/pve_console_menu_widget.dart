import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:proxmox_dart_api_client/proxmox_dart_api_client.dart';
import 'package:flutter/foundation.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PveConsoleMenu extends StatelessWidget {
  static const platform =
      const MethodChannel('com.proxmox.app.pve_flutter_frontend/filesharing');
  final ProxmoxApiClient apiClient;
  final String? guestID;
  final bool? allowSpice;
  final String node;
  final String type;

  const PveConsoleMenu({
    Key? key,
    required this.apiClient,
    this.guestID,
    required this.node,
    required this.type,
    this.allowSpice = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _allowSpice = allowSpice ?? true;
    return SingleChildScrollView(
      child: Container(
        constraints:
            BoxConstraints(minHeight: MediaQuery.of(context).size.height / 3),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (Platform.isAndroid && _allowSpice)
              ListTile(
                title: Text(
                  "SPICE",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text("Open SPICE connection file with external App"),
                onTap: () async {
                  if (Platform.isAndroid) {
                    final tempDir = await getExternalCacheDirectories();

                    var apiPath;
                    if (['qemu', 'lxc'].contains(type)) {
                      apiPath = '/nodes/$node/$type/$guestID/spiceproxy';
                    } else if (type == 'node') {
                      apiPath = '/nodes/$node/spiceshell';
                    } else {
                      throw 'Unsupported console type "$type", must be one of "qemu", "lxc", "node"';
                    }
                    final response = await apiClient.postRequest(apiPath);
                    final data = json.decode(response.body)['data'];
                    if (data == null) {
                      showTextDialog(context, 'Empty reply from SPICE API',
                          'Ensure you have "${type == 'node' ? 'Sys' : 'VM'}.Console" permissions.');
                      return;
                    }
                    var filePath = await writeSpiceFile(data, tempDir![0].path);

                    try {
                      await platform.invokeMethod('shareFile', {
                        'path': filePath,
                        'type': 'application/x-virt-viewer'
                      });
                    } on PlatformException catch (e, s) {
                      if (e.code.contains('ActivityNotFoundException')) {
                        showTextDialog(context, 'SPICE client required',
                            'A Spice client-app is required.');
                      } else {
                        debugPrint("$e $s");
                        if (e.message != null) {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Got Exception'),
                              content: Text(e.message!),
                              actions: [
                                FlatButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: Text('Close'))
                              ],
                            ),
                          );
                        }
                      }
                    }
                  } else {
                    print('not implemented for current platform');
                  }
                },
              ),
            if (Platform.isAndroid) // web_view is only available for mobile :(
              ListTile(
                title: Text(
                  //type == "qemu" ? "noVNC Console" : "xterm.js Console",
                  "noVNC Console", // xterm.js doesn't work that well on mobile
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                    "Open console view (requires trusted SSL certificate)"),
                onTap: () async {
                  if (Platform.isAndroid) {
                    if (['qemu', 'lxc'].contains(type)) {
                      SystemChrome.setEnabledSystemUIMode(
                          SystemUiMode.immersive);
                      Navigator.of(context)
                          .push(_createHTMLConsoleRoute())
                          .then((completion) {
                        SystemChrome.setEnabledSystemUIMode(
                            SystemUiMode.edgeToEdge,
                            overlays: [
                              SystemUiOverlay.top,
                              SystemUiOverlay.bottom
                            ]);
                      });
                    } else if (type == 'node') {
                      SystemChrome.setEnabledSystemUIMode(
                          SystemUiMode.immersive);
                      Navigator.of(context)
                          .push(_createHTMLConsoleRoute())
                          .then((completion) {
                        SystemChrome.setEnabledSystemUIMode(
                            SystemUiMode.edgeToEdge,
                            overlays: [
                              SystemUiOverlay.top,
                              SystemUiOverlay.bottom
                            ]);
                      });
                    }
                  } else {
                    print('not implemented for current platform');
                  }
                },
              ),
          ],
        ),
      ),
    );
  }

  void showTextDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          FlatButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'))
        ],
      ),
    );
  }

  Future<String> writeSpiceFile(Map data, String path) async {
    var vvFileContent = '[virt-viewer]\n';

    data.forEach((key, value) {
      if (key == 'proxy' && type != 'node') {
        final proxy = apiClient.credentials.apiBaseUrl
            .replace(port: 3128, scheme: 'http');
        vvFileContent += '$key=$proxy\n';
      } else {
        vvFileContent += '$key=$value\n';
      }
    });
    final vvFile = File('$path/vvFile.vv');
    await vvFile.writeAsString(vvFileContent, flush: true);
    return vvFile.path;
  }

  Route _createHTMLConsoleRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => PVEWebConsole(
        apiClient: apiClient,
        node: node,
        guestID: guestID,
        type: type,
      ),
    );
  }
}

class PVEWebConsole extends StatefulWidget {
  final ProxmoxApiClient apiClient;
  final String node;
  final String? guestID;
  final String? type;

  const PVEWebConsole({
    Key? key,
    required this.apiClient,
    required this.node,
    this.guestID,
    this.type,
  }) : super(key: key);

  @override
  PVEWebConsoleState createState() => PVEWebConsoleState();
}

class PVEWebConsoleState extends State<PVEWebConsole> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    final ticket = widget.apiClient.credentials.ticket!;
    final baseUrl = widget.apiClient.credentials.apiBaseUrl;

    var consoleUrl = "${baseUrl}/?novnc=1&node=${widget.node}&isFullscreen=true&resize=scale";
    if (widget.guestID != null) {
      final consoleType = widget.type == 'lxc' ? 'lxc' : 'kvm';
      consoleUrl += "&console=${consoleType}&vmid=${widget.guestID}";
    } else {
      consoleUrl += "&console=shell";
    }
    //debugPrint("url: ${consoleUrl}, ticket: $ticket");

    return SafeArea(
      child: WebView(
        javascriptMode: JavascriptMode.unrestricted,
        backgroundColor: Theme.of(context).colorScheme.background,
        initialCookies: <WebViewCookie>[
          WebViewCookie(
            name: 'PVEAuthCookie',
            value: ticket,
            domain: baseUrl.origin,
          )
        ],
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
          webViewController.loadUrl(consoleUrl);
        },
      ),
    );
  }
}
