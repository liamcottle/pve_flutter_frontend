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
                    var filePath = '';

                    if (['qemu', 'lxc'].contains(type)) {
                      final response = await apiClient.postRequest(
                          '/nodes/$node/$type/$guestID/spiceproxy');
                      final data = json.decode(response.body)['data'];
                      filePath = await writeSpiceFile(data, tempDir[0].path);
                    }

                    if (type == 'node') {
                      final response = await apiClient
                          .postRequest('/nodes/$node/spiceshell');
                      final data = json.decode(response.body)['data'];
                      filePath = await writeSpiceFile(data, tempDir[0].path);
                    }

                    try {
                      await platform.invokeMethod('shareFile', {
                        'path': filePath,
                        'type': 'application/x-virt-viewer'
                      });
                    } on PlatformException catch (e) {
                      if (e.code.contains('ActivityNotFoundException')) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('SPICE client required'),
                            content: Text(
                                'A Spice client is required on this device.'),
                            actions: [
                              FlatButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: Text('Close'))
                            ],
                          ),
                        );
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
