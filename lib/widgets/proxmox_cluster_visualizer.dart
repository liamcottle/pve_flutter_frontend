import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class ProxmoxClusterVisualizer extends CustomPainter {
  static const seedRadius = 5.0;
  static const scaleFactor = 15;
  static const tau = math.pi * 2;

  static final phi = (math.sqrt(5) + 1) / 2;

  final int seeds;

  ProxmoxClusterVisualizer(this.seeds);

  @override
  void paint(Canvas canvas, Size size) {
    // var center = size.width / 2;

    for (var i = 0; i < seeds; i++) {
      //var theta = i * tau / phi;
      //var r = math.sqrt(i) * scaleFactor;

      // var x = center + r * math.cos(theta);
      // var y = center - r * math.sin(theta);

      var x = size.width / 4 * i;
      var y = size.height / 2;
      var offset = Offset(x, y);
      if (!size.contains(offset)) {
        continue;
      }
      drawSeed(canvas, x, y);
    }
  }

  @override
  bool shouldRepaint(ProxmoxClusterVisualizer oldDelegate) {
    return oldDelegate.seeds != this.seeds;
  }

  void drawSeed(Canvas canvas, num x, num y) {
    // var paint = Paint()
    //   ..strokeWidth = 2
    //   ..style = PaintingStyle.fill
    //   ..color = Colors.green;
    // canvas.drawCircle(Offset(x, y), seedRadius, paint);
    final icon = Icons.storage;
    var builder = ui.ParagraphBuilder(
        ui.ParagraphStyle(fontFamily: icon.fontFamily, fontSize: 60))
      ..addText(String.fromCharCode(icon.codePoint));
    var para = builder.build();
    para.layout(const ui.ParagraphConstraints(width: 60));
    canvas.drawParagraph(para, Offset(x, y));
  }
}
