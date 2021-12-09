import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:proxmox_dart_api_client/proxmox_dart_api_client.dart';
import 'package:flutter/foundation.dart';

class PveConsoleMenu extends StatelessWidget {
  static const platform =
      const MethodChannel('com.proxmox.app.pve_flutter_frontend/filesharing');
  final ProxmoxApiClient apiClient;
  final String guestID;
  final String node;
  final String type;

  const PveConsoleMenu(
      {Key key,
      @required this.apiClient,
      this.guestID,
      @required this.node,
      @required this.type})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        constraints:
            BoxConstraints(minHeight: MediaQuery.of(context).size.height / 3),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (Platform.isAndroid)
              ListTile(
                title: Text(
                  "SPICE",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text("Open SPICE connection file"),
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
                    var filePath = await writeSpiceFile(data, tempDir[0].path);

                    try {
                      await platform.invokeMethod('shareFile', {
                        'path': filePath,
                        'type': 'application/x-virt-viewer'
                      });
                    } on PlatformException catch (e) {
                      if (e.code.contains('ActivityNotFoundException')) {
                        showTextDialog(context, 'SPICE client required',
                            'A Spice client-app is required.');
                      }
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
}
