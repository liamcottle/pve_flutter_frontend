import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pve_flutter_frontend/utils/renderers.dart';
import 'package:pve_flutter_frontend/widgets/proxmox_line_chart.dart';

class PveRRDChart extends StatefulWidget {
  final String title;
  final double titleWidth;
  final String subtitle;
  final EdgeInsetsGeometry titlePadding;
  final Iterable<Point<num>> data;
  final Widget icon;
  final Color lineColor;
  final double staticMaximum;
  final Color shadeColorTop;
  final Color shadeColorBottom;
  final CrossAxisAlignment titleAlginment;
  final bool showMaximum;
  final bool showDuration;
  final Widget bottomRight;
  final String unit;

  const PveRRDChart({
    Key key,
    this.title,
    this.subtitle,
    this.data,
    this.icon,
    this.lineColor = Colors.white,
    this.staticMaximum,
    this.shadeColorTop = Colors.white,
    this.shadeColorBottom = const Color(0x00FFFFFF),
    this.titleAlginment = CrossAxisAlignment.start,
    this.titleWidth,
    this.titlePadding,
    this.showMaximum = true,
    this.showDuration = true,
    this.bottomRight,
    this.unit = '',
  }) : super(key: key);

  @override
  _PveRRDChartState createState() => _PveRRDChartState();
}

class _PveRRDChartState extends State<PveRRDChart> {
  Point touchpoint;
  @override
  Widget build(BuildContext context) {
    final globalMaxima =
        widget.data.map((e) => e.y).reduce((a, b) => max(a ?? 0, b ?? 0));
    final globalMaximaLabel = globalMaxima?.toStringAsFixed(2) ?? '';
    final timeWindow = DateTime.fromMillisecondsSinceEpoch(widget.data.last.x)
        .difference(DateTime.fromMillisecondsSinceEpoch(widget.data.first.x));
    return Column(
      crossAxisAlignment: widget.titleAlginment,
      children: <Widget>[
        Container(
          width: widget.titleWidth ?? null,
          padding: widget.titlePadding ?? null,
          child: ListTile(
            leading: widget.icon,
            title: Text(
              widget.title,
              style: TextStyle(
                  fontSize: 12,
                  color: Colors.white60,
                  fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              '${widget.subtitle} ${widget.unit}',
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        if (widget.showMaximum)
          Row(
            children: [
              Text(
                'max $globalMaximaLabel ${widget.unit}',
                style: TextStyle(color: Colors.white60, fontSize: 11),
              ),
            ],
          ),
        Expanded(
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: GestureDetector(
              onPanDown: (details) {
                setState(() {
                  touchpoint = Point(
                    details.globalPosition.dx,
                    details.globalPosition.dy,
                  );
                });
              },
              child: CustomPaint(
                painter: ProxmoxLineChart(
                    data: widget.data?.toList(),
                    lineColor: widget.lineColor,
                    staticMax: widget.staticMaximum,
                    shadeColorBottom: widget.shadeColorBottom,
                    shadeColorTop: widget.shadeColorTop,
                    touchPoint: touchpoint,
                    yUnit: widget.unit),
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('past ' + Renderers.renderDuration(timeWindow) ?? '',
                style: TextStyle(color: Colors.white60, fontSize: 11)),
            if (widget.bottomRight != null) widget.bottomRight,
          ],
        ),
      ],
    );
  }
}
