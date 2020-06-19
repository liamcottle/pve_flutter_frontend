import 'package:flutter/material.dart';

class LineDashedPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..strokeWidth = 1
      ..color = Colors.black26;
    var max = 35;
    var dashWidth = 5;
    var dashSpace = 5;
    double startX = 0;
    while (max >= 0) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      final space = (dashSpace + dashWidth);
      startX += space;
      max -= space;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
