import 'package:flutter/material.dart';
import 'package:proxmox_dart_api_client/proxmox_dart_api_client.dart';
import 'package:pve_flutter_frontend/utils/renderers.dart';

class PveGuestIcon extends StatelessWidget {
  final String type;
  final bool? template;
  final PveResourceStatusType? status;
  final Color color;
  final Color templateColor;

  const PveGuestIcon({
    Key? key,
    required this.type,
    this.template = false,
    required this.status,
    this.color = Colors.grey,
    this.templateColor = Colors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (template!) {
      return Container(
        height: 24,
        width: 36,
        child: Stack(
          children: [
            Icon(
              Renderers.getDefaultResourceIcon(type),
              color: color,
              size: 24,
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Icon(
                Icons.content_paste,
                color: templateColor,
                size: 14,
              ),
            ),
          ],
        ),
      );
    }
    return Icon(
      Renderers.getDefaultResourceIcon(type),
      color:
          status == PveResourceStatusType.running ? Color(0xFF21bf4b) : color,
    );
  }
}
