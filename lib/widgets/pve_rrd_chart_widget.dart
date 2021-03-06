import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pve_flutter_frontend/utils/renderers.dart';
import 'package:pve_flutter_frontend/widgets/proxmox_line_chart.dart';

class PveRRDChart extends StatefulWidget {
  final String? title;
  final double? titleWidth;
  final String? subtitle;
  final EdgeInsetsGeometry? titlePadding;
  final Iterable<Point<num>>? data;
  final Widget? icon;
  final Color? lineColor;
  final double? staticMaximum;
  final Color? shadeColorTop;
  final Color? shadeColorBottom;
  final CrossAxisAlignment titleAlginment;
  final bool showMaximum;
  final bool showDuration;
  final Widget? bottomRight;
  final DataRenderer? dataRenderer;

  const PveRRDChart({
    Key? key,
    this.title,
    this.subtitle,
    this.data,
    this.icon,
    this.lineColor,
    this.staticMaximum,
    this.shadeColorTop,
    this.shadeColorBottom,
    this.titleAlginment = CrossAxisAlignment.start,
    this.titleWidth,
    this.titlePadding,
    this.showMaximum = true,
    this.showDuration = true,
    this.bottomRight,
    this.dataRenderer,
  }) : super(key: key);

  @override
  _PveRRDChartState createState() => _PveRRDChartState();
}

class _PveRRDChartState extends State<PveRRDChart> {
  Point? touchpoint;
  @override
  Widget build(BuildContext context) {
    final data = widget.data!.isNotEmpty ? widget.data! : [Point(0, 0)];
    final globalMaxima = data.map((e) => e.y).reduce((a, b) => max(a, b));
    final globalMaximaLabel =
        globalMaxima.toStringAsFixed(globalMaxima < 0.01 ? 3 : 2);
    final timeWindow = DateTime.fromMillisecondsSinceEpoch(data.last.x as int)
        .difference(DateTime.fromMillisecondsSinceEpoch(data.first.x as int));

    final fgColor = Theme.of(context).colorScheme.onPrimary.withOpacity(0.85);
    return Column(
      crossAxisAlignment: widget.titleAlginment,
      children: <Widget>[
        Container(
          width: widget.titleWidth ?? null,
          padding: widget.titlePadding ?? null,
          child: ListTile(
            leading: widget.icon,
            title: Text(
              widget.title!,
              style: TextStyle(
                  fontSize: 12, color: fgColor, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              '${widget.subtitle}',
              style: TextStyle(
                  fontSize: 20, color: fgColor, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        if (widget.showMaximum)
          Row(
            children: [
              Text(
                widget.dataRenderer != null
                    ? 'max ' + widget.dataRenderer!(globalMaxima)
                    : 'max $globalMaximaLabel',
                style: TextStyle(color: fgColor, fontSize: 11),
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
                    data: data.toList(),
                    textColor: widget.lineColor ??
                        Theme.of(context).colorScheme.onPrimary,
                    lineColor: widget.lineColor ??
                        Theme.of(context).colorScheme.onPrimary,
                    staticMax: widget.staticMaximum,
                    shadeColorBottom: widget.shadeColorBottom ??
                        Theme.of(context).colorScheme.primary,
                    shadeColorTop: widget.shadeColorTop ??
                        Theme.of(context).colorScheme.onPrimary,
                    touchPoint: touchpoint,
                    ordinateRenderer: widget.dataRenderer),
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('past ' + Renderers.renderDuration(timeWindow),
                style: TextStyle(color: fgColor, fontSize: 11)),
            if (widget.bottomRight != null) widget.bottomRight!,
          ],
        ),
      ],
    );
  }
}
