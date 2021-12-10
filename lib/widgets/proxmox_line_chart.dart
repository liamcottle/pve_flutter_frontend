import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

typedef DataRenderer = String Function(num data);

class ProxmoxLineChart extends CustomPainter {
  final List<Point>? data;
  final Color? lineColor;
  final Color shadeColorTop;
  final Color shadeColorBottom;
  final double? staticMax;
  final Point? touchPoint;
  final DataRenderer? ordinateRenderer;
  ProxmoxLineChart({
    this.data,
    this.lineColor,
    this.staticMax,
    this.shadeColorTop = Colors.white,
    this.shadeColorBottom = const Color(0x00FFFFFF),
    this.touchPoint,
    this.ordinateRenderer,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data?.isEmpty ?? true) return;

    var paint = Paint();
    paint.color = lineColor!;
    paint.strokeWidth = 1;

    var path = Path();
    final globalMaxima = data!.map((e) => e.y).reduce((a, b) => max(a, b));
    final points = convertDataToPoints(data!, size, staticMax ?? globalMaxima);
    points.asMap().forEach((i, el) {
      if (i == 0) {
        path.moveTo(el.x as double, el.y as double? ?? size.height);
        return;
      }

      final cp1 = Offset((points[i].x + points[i - 1].x) / 2,
          points[i - 1].y as double? ?? size.height);
      final cp2 = Offset((points[i].x + points[i - 1].x) / 2,
          points[i].y as double? ?? size.height);
      path.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, el.x as double,
          el.y as double? ?? size.height);
    });

    if (touchPoint != null) {
      final index = closestX(touchPoint, points);
      final selectedLabel = (ordinateRenderer != null
              ? ordinateRenderer!(data?[index].y ?? 0)
              : data?[index].y.toStringAsFixed(2)) ??
          '-';
      TextSpan span = TextSpan(
        style: TextStyle(
          color: Colors.white,
        ),
        text: selectedLabel,
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

      tp.paint(canvas, Offset(tpX, points[index].y as double? ?? size.height));
      canvas.drawCircle(
          Offset(points[index].x as double,
              points[index].y as double? ?? size.height),
          2,
          paint);
    }

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
      if (e.y == null) return;
      final y = bottomY - (e.y / maxima * (bottomY));
      converted.add(Point(xDiff * i, y));
    });
    return converted;
  }

  int closestX(Point? touchPoint, List<Point> convertedPoints) {
    return convertedPoints.indexWhere((element) => element.x >= touchPoint!.x);
  }
}
