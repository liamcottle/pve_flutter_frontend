import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pve_flutter_frontend/widgets/proxmox_line_chart.dart';

class ProxmoxHeartbeatIndicator extends StatelessWidget {
  final bool isHealthy;
  final Color healthyColor;
  final Color warningColor;

  const ProxmoxHeartbeatIndicator({
    Key key,
    @required this.isHealthy,
    this.healthyColor,
    this.warningColor,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
        painter: ProxmoxLineChart(
      data: [
        Point(0.0, 2.0),
        Point(0.0, 2.0),
        Point(0.0, 2.0),
        Point(0.0, 2.0),
        Point(0.0, 1.0),
        Point(0.0, 3.0),
        Point(0.0, 2.0),
        Point(0.0, 1.0),
        Point(0.0, 8.0),
        Point(0.0, 0.0),
        Point(0.0, 2.0),
        Point(0.0, 2.0),
        Point(0.0, 3.0),
        Point(0.0, 2.0),
        Point(0.0, 2.0),
        Point(0.0, 2.0),
      ],
      lineColor: isHealthy ? healthyColor : warningColor,
    ));
  }
}
