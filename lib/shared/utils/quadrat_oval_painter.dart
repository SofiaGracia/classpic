import 'package:flutter/material.dart';

class GuideOvalSquarePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rectPaint = Paint()
      ..color = Colors.transparent;

    final ovalPaint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final side = size.width * 0.6;
    final left = (size.width - side) / 2;
    final top = (size.height - side) / 2;
    final rect = Rect.fromLTWH(left, top, side, side);

    // Només dibuixem la línia oval
    canvas.drawOval(rect, ovalPaint);

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}