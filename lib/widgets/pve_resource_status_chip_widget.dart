import 'package:flutter/material.dart';
import 'package:proxmox_dart_api_client/proxmox_dart_api_client.dart';

class StatusChip extends StatelessWidget {
  final PveResourceStatusType status;
  final double fontzsize;
  final FontWeight fontWeight;
  final Color offlineColor;
  final Color intermediateColor;

  final Color onlineColor;
  const StatusChip({
    Key key,
    this.status,
    this.fontzsize = 12,
    this.fontWeight = FontWeight.normal,
    this.offlineColor = Colors.grey,
    this.onlineColor = const Color(0xFF21bf4b),
    this.intermediateColor = Colors.orange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    String statusText;
    switch (status) {
      case PveResourceStatusType.running:
        statusColor = onlineColor;
        statusText = 'online';
        break;
      case PveResourceStatusType.stopped:
        statusColor = offlineColor;
        statusText = 'offline';
        break;
      case PveResourceStatusType.suspended:
        statusColor = offlineColor;
        statusText = 'suspended';
        break;
      case PveResourceStatusType.paused:
        statusColor = intermediateColor;
        statusText = 'paused';
        break;
      case PveResourceStatusType.suspending:
        statusColor = intermediateColor;
        statusText = 'suspending';
        break;
      default:
        statusColor = offlineColor;
        statusText = 'unkown';
    }
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: statusColor, width: 1.8),
          borderRadius: BorderRadius.circular(3.0)),
      child: Padding(
        padding: const EdgeInsets.all(2.5),
        child: Text(
          statusText,
          style: TextStyle(
              color: statusColor, fontSize: fontzsize, fontWeight: fontWeight),
        ),
      ),
    );
  }
}
