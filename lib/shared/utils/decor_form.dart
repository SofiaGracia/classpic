import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xml_fotos/shared/utils/constants.dart';

class DecorForm extends CustomPainter {
  final Size sizeScreen;
  final double rectWidth;
  final double rectHeight;
  final double rectLeftPosition;
  final double rectTopPosition;
  final Color color;
  final double strokeW;

  const DecorForm(
      {required this.sizeScreen,
      required this.rectWidth,
      required this.rectHeight,
      required this.rectLeftPosition,
      required this.rectTopPosition,
        required this.color,
        required this.strokeW,
      });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = strokeW;

    double left = rectLeftPosition;
    double top = rectTopPosition;

    //Decorative pattern
    final Rect rect = Rect.fromLTWH(left, top, rectWidth, rectHeight);

    final path = Path();
    path.addArc(rect, pi * 2, pi / 2);
    path.arcToPoint(Offset(left + (rectWidth + 50), top + (rectHeight + 50)));
    path.lineTo(left + rectWidth, top + rectHeight / 2);
    path.close();
    


    //Rect with the size of the screen
    final Rect rectScreen = Rect.fromLTWH(0, 0, sizeScreen.width, sizeScreen.height);

    //Draw the form
    canvas.drawPath(path, paint);

    //TODO: Then we cut the form with the rectScreen so we don't loose memory

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
