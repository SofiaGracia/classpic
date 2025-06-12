import 'package:flutter/material.dart';

class GuideOvalPainter extends CustomPainter {

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // 1. Mides de l'òval
    final shortestSide = size.shortestSide;
    final ovalWidth = shortestSide * 0.6;
    final ovalHeight = shortestSide * 0.8;

    // 2. Posició perquè quede centrat
    final double leftOval = (size.width - ovalWidth) / 2;
    final double topOval = (size.height - ovalHeight) / 2;

    // 3. Rectangle que conté l'òval
    final Rect ovalRect = Rect.fromLTWH(leftOval, topOval, ovalWidth, ovalHeight);

    // 4. Dibuixar l'òval sobre el canvas
    canvas.drawOval(ovalRect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
