import 'package:flutter/material.dart';

class GuideSquarePainter extends CustomPainter {
  final double widthSquare;
  final double heightSquare;
  final double widthShadow;
  final double heightShadow;

  const GuideSquarePainter(
      {required this.widthSquare,
      required this.heightSquare,
      required this.widthShadow,
      required this.heightShadow});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Calcul del quadrat central
    final double left = (size.width - widthSquare) / 2;
    final double top = (size.height - heightSquare) / 2;
    final Rect squareRect = Rect.fromLTWH(left, top, widthSquare, heightSquare);

    canvas.drawRect(squareRect, paint);

    // 🕶️ Dibuixar màscara fosca fora del quadrat
    final Path fullScreen = Path()
      ..addRect(Rect.fromLTWH(0, 0, widthShadow, heightShadow));
    final Path cutout = Path()..addRect(squareRect);

    final Path shadow = Path.combine(
      PathOperation.difference,
      fullScreen,
      cutout,
    );

    final Paint shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    canvas.drawPath(shadow, shadowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
