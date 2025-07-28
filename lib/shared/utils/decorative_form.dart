import 'dart:math';
import 'package:flutter/material.dart';

import '../../domain/models/shape_config.dart';

class MultiDecorFormPainter extends CustomPainter {
  final List<ShapeConfig> shapes;
  final Size sizeScreen;
  final double strokeW;

  MultiDecorFormPainter({
    required this.shapes,
    required this.sizeScreen,
    this.strokeW = 240,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.clipRect(Rect.fromLTWH(0, 0, sizeScreen.width, sizeScreen.height));

    for (final shape in shapes) {
      final paint = Paint()
        ..color = shape.color
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.square
        ..strokeJoin = StrokeJoin.round
        ..strokeWidth = strokeW;

      final radius = sizeScreen.width / 2;
      final center = Offset(shape.leftPosition, shape.topPosition);

      final circle = Rect.fromCircle(center: center, radius: radius);
      final rectInside = Rect.fromLTWH(shape.sqrLeft, shape.sqrTop, radius, radius);

      final pathOne = Path()..addOval(circle);
      final pathTwo = Path()..addRect(rectInside);

      final path = Path.combine(
        PathOperation.reverseDifference,
        pathOne,
        pathTwo,
      );

      canvas.drawPath(path, paint);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant MultiDecorFormPainter oldDelegate) =>
      oldDelegate.shapes != shapes || oldDelegate.strokeW != strokeW;
}