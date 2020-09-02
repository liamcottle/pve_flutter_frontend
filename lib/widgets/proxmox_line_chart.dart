import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:pve_flutter_frontend/utils/renderers.dart';

class ProxmoxLineChart extends CustomPainter {
  final List<Point> data;
  final Color lineColor;
  final Color shadeColorTop;
  final Color shadeColorBottom;
  final double staticMax;
  final Point touchPoint;
  final String yUnit;
  ProxmoxLineChart({
    this.data,
    this.lineColor,
    this.staticMax,
    this.shadeColorTop = Colors.white,
    this.shadeColorBottom = const Color(0x00FFFFFF),
    this.touchPoint,
    this.yUnit = '',
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data?.isEmpty ?? true) return;

    var paint = Paint();
    paint.color = lineColor;
    paint.strokeWidth = 1;

    var path = Path();
    final globalMaxima =
        data.map((e) => e.y).reduce((a, b) => max(a ?? 0, b ?? 0));
    final points = convertDataToPoints(data, size, staticMax ?? globalMaxima);
    points.asMap().forEach((i, el) {
      if (i == 0) {
        path.moveTo(el.x, el.y ?? size.height);
        return;
      }

      final cp1 = Offset(
          (points[i].x + points[i - 1].x) / 2, points[i - 1].y ?? size.height);
      final cp2 = Offset(
          (points[i].x + points[i - 1].x) / 2, points[i].y ?? size.height);
      path.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, el.x, el.y ?? size.height);
    });

    if (touchPoint != null) {
      final index = closestX(touchPoint, points);
      final selectedLabel = data[index].y?.toStringAsFixed(2) ?? '';
      TextSpan span = TextSpan(
        style: TextStyle(
          color: Colors.white,
        ),
        text: '$selectedLabel $yUnit',
      );
      TextPainter tp = TextPainter(
        text: span,
        textAlign: TextAlign.left,
        textDirection: TextDirection.ltr,
      );
      tp.layout();

      // prevent right/left overflow
      var tpX;
      if (tp.width <= points[index].x) {
        tpX = points[index].x - tp.width;
      } else {
        tpX = points[index].x;
      }

      tp.paint(canvas, Offset(tpX, points[index].y ?? size.height));
      canvas.drawCircle(
          Offset(points[index].x, points[index].y ?? size.height), 2, paint);
    }

    canvas.drawLine(Offset(0, 0), Offset(5, 0), paint);

    //TODO gaps between datapoints
    paint.style = PaintingStyle.stroke;
    canvas.drawPath(path, paint);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    final shaderHeight =
        globalMaxima > size.height ? size.height : globalMaxima;
    paint.shader = ui.Gradient.linear(
        Offset(size.width, 0),
        Offset(0, 0),
        [
          shadeColorBottom,
          shadeColorTop,
        ],
        [0.25, 1.0],
        TileMode.clamp,
        GradientRotation(pi / 2)
            .transform(Rect.fromPoints(
                Offset(size.width, shaderHeight.toDouble()), Offset(0, 0)))
            .storage);
    paint.style = PaintingStyle.fill;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  List<Point> convertDataToPoints(List<Point> data, Size size, num maxima) {
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

  int closestX(Point touchPoint, List<Point> convertedPoints) {
    return convertedPoints.indexWhere((element) => element.x >= touchPoint.x);
  }
}
