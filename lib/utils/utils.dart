import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proxmox_dart_api_client/proxmox_dart_api_client.dart';
import 'package:pve_flutter_frontend/bloc/pve_task_log_viewer_bloc.dart';
import 'package:pve_flutter_frontend/states/pve_task_log_viewer_state.dart';
import 'package:pve_flutter_frontend/widgets/pve_task_log_widget.dart';
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

Future<T> showTaskLogBottomSheet<T>(BuildContext context,
    ProxmoxApiClient apiClient, String targetNode, String upid,
    {Widget icon = const Icon(Icons.work),
    Widget jobTitle = const Text('Job')}) async {
  return showModalBottomSheet(
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
    context: context,
    builder: (context) => Provider(
      create: (context) => PveTaskLogViewerBloc(
        apiClient: apiClient,
        init: PveTaskLogViewerState.init(
          targetNode,
          upid: upid,
        ),
      ),
      child: PveTaskLogScrollView(
        icon: icon,
        jobTitle: jobTitle,
      ),
    ),
  );
}
