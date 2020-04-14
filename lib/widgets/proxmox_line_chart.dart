import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class ProxmoxLineChart extends CustomPainter {
  final List<Point> data;
  final Color lineColor;
  ProxmoxLineChart({this.data, this.lineColor});

  @override
  void paint(Canvas canvas, Size size) {
    if (data?.isEmpty ?? true) return;

    var paint = Paint();
    paint.color = lineColor;
    paint.strokeWidth = 1;

    var path = Path();
    final globalMaxima =
        data.map((e) => e.y).reduce((a, b) => max(a ?? 0, b ?? 0));
    final points = convertDataToPoints(data, size, globalMaxima);
    points.asMap().forEach((i, el) {
      if (i == 0) {
        path.moveTo(el.x, el.y);
        return;
      }

      if (el.y == null) {
        path.moveTo(el.x, size.height);
        return;
      }

      final cp1 = Offset(
          (points[i].x + points[i - 1].x) / 2, points[i - 1].y ?? size.height);
      final cp2 = Offset(
          (points[i].x + points[i - 1].x) / 2, points[i].y ?? size.height);
      path.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, el.x, el.y);
    });
    //TODO gaps between datapoints
    paint.style = PaintingStyle.stroke;
    canvas.drawPath(path, paint);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    paint.shader = ui.Gradient.linear(
        Offset(size.width, globalMaxima),
        Offset(0, 0),
        [
          Color(0x00FFFFFF),
          Colors.white,
        ],
        [0.25, 1.0],
        TileMode.clamp,
        GradientRotation(pi / 2)
            .transform(
                Rect.fromPoints(Offset(size.width, globalMaxima), Offset(0, 0)))
            .storage);
    paint.style = PaintingStyle.fill;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  List<Point> convertDataToPoints(List<Point> data, Size size, double maxima) {
    if (data.isEmpty) return [];

    final bottomY = size.height;
    final xDiff = size.width / (data.length - 1);

    final List<Point> converted = [];
    data.asMap().forEach((i, e) {
      final y = e.y != null ? bottomY - (e.y / maxima * (bottomY)) : null;
      converted.add(Point(xDiff * i, y));
    });
    return converted;
  }
}
