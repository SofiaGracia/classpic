import 'package:flutter/material.dart';

class GuideOvalPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // 1. Mides de l'òval
    final double ovalWidth = size.width / 2;
    final double ovalHeight = size.height / 3;

    // 2. Posició perquè quede centrat
    final double left = (size.width - ovalWidth) / 2;
    final double top = (size.height - ovalHeight) / 2;

    // 3. Rectangle que conté l'òval
    final Rect ovalRect = Rect.fromLTWH(left, top, ovalWidth, ovalHeight);

    // 4. Dibuixar l'òval sobre el canvas
    canvas.drawOval(ovalRect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
