import 'package:proxmox_dart_api_client/proxmox_dart_api_client.dart';
import 'package:url_launcher/url_launcher.dart';

void registerConsoleIframe(String nodeid) => throw UnimplementedError();

Future<bool> launchDocURL(String docPath) async {
  var url = await getPlatformAwareOrigin() + docPath;
  if (await canLaunch(url)) {
    return await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
