import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

typedef DataRenderer = String Function(num data);

class ProxmoxLineChart extends CustomPainter {
  final List<Point>? data;
  final Color? lineColor;
  final Color? textColor;
  final Color shadeColorTop;
  final Color shadeColorBottom;
  final double? staticMax;
  final Point? touchPoint;
  final DataRenderer? ordinateRenderer;
  ProxmoxLineChart({
    this.data,
    this.lineColor,
    this.textColor,
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
    // FIXME: add wrapper widget with access to the (theme) context so we can
    // have better defaults!
    paint.color = lineColor ?? Colors.white;
    paint.strokeWidth = 2;

    var path = Path();
    final globalMaxima = max(
      data!.map((e) => e.y).reduce((a, b) => max(a, b)),
      0.001, // avoid that almost zero usage looks like a high load
    );
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
        [shadeColorBottom, shadeColorTop],
        [0.25, 1.0],
        TileMode.clamp,
        GradientRotation(pi / 2)
            .transform(Rect.fromPoints(
                Offset(size.width, shaderHeight.toDouble()), Offset(0, 0)))
            .storage);
    paint.style = PaintingStyle.fill;
    canvas.drawPath(path, paint);

    if (touchPoint != null) {
      final closest = closestX(touchPoint, points);
      final index = closest > 0 ? closest : 0;
      final selectedLabel = (ordinateRenderer != null
              ? ordinateRenderer!(data?[index].y ?? 0)
              : data?[index].y.toStringAsFixed(2)) ??
          '-';
      TextPainter tp = TextPainter(
        text: TextSpan(
          style: TextStyle(
            color: textColor ?? Colors.white,
            backgroundColor: shadeColorBottom.withOpacity(0.75),
          ),
          text: selectedLabel,
        ),
        textAlign: TextAlign.left,
        textDirection: TextDirection.ltr,
      );
      tp.layout();

      final touchX = points[index].x as double;
      final touchY = points[index].y as double;
      if (!touchX.isNaN && !touchY.isNaN) {
        // prevent right/left overflow
        final labelX = tp.width <= touchX ? touchX - tp.width : touchX;
        var labelY = true || tp.height < touchY + paint.strokeWidth
            ? touchY - tp.height - paint.strokeWidth
            : touchY;

        tp.paint(canvas, Offset(labelX, labelY));
        canvas.drawCircle(Offset(touchX, touchY), 4, paint);
        paint.color = Colors.white;
        canvas.drawCircle(Offset(touchX, touchY), 2, paint);
      }
    }
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
