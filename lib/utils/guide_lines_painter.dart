import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GuideLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..strokeWidth = 1;

    // Terços verticals
    //final thirdWidth = size.width / 3;
    final halfWidth = size.width / 2;
    final thirdHeight = size.height / 3;

    final margin = 50.0;

    canvas.drawLine(Offset(halfWidth, thirdHeight), Offset(halfWidth, (thirdHeight * 2)), paint);

    // Terços horitzontals
    canvas.drawLine(Offset(margin, thirdHeight), Offset((size.width - margin), thirdHeight), paint);
    canvas.drawLine(Offset(margin, thirdHeight * 2), Offset((size.width - margin), thirdHeight * 2), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
