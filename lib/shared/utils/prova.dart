import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';

//Add this CustomPaint widget to the Widget Tree
//Copy this CustomPainter code to the Bottom of the File
class RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(88.28, 353.1);
    path_0.lineTo(88.28, 158.9);
    path_0.lineTo(177.88, 210.54);
    path_0.lineTo(177.88, 301.02);
    path_0.lineTo(88.28, 353.1);
    path_0.close();

    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.color = Color.fromRGBO(222, 101, 71, 1.0).withOpacity(1.0);
    canvas.drawPath(path_0, paint_0_fill);

    Path path_1 = Path();
    path_1.moveTo(256.44, 450.65);
    path_1.lineTo(256.44, 348.69);
    path_1.lineTo(177.43, 301.02);
    path_1.lineTo(88.28, 353.1);
    path_1.lineTo(256.44, 450.65);
    path_1.close();

    Paint paint_1_fill = Paint()..style = PaintingStyle.fill;
    paint_1_fill.color = Color.fromRGBO(253, 188, 77, 1.0).withOpacity(1.0);
    canvas.drawPath(path_1, paint_1_fill);

    Path path_2 = Path();
    path_2.moveTo(423.72, 353.1);
    path_2.lineTo(423.72, 158.9);
    path_2.lineTo(334.12, 210.54);
    path_2.lineTo(334.12, 301.02);
    path_2.lineTo(423.72, 353.1);
    path_2.close();

    Paint paint_2_fill = Paint()..style = PaintingStyle.fill;
    paint_2_fill.color = Color.fromRGBO(105, 179, 86, 1.0).withOpacity(1.0);
    canvas.drawPath(path_2, paint_2_fill);

    Path path_3 = Path();
    path_3.moveTo(256.44, 450.65);
    path_3.lineTo(256.44, 348.69);
    path_3.lineTo(334.57, 301.02);
    path_3.lineTo(423.72, 353.1);
    path_3.lineTo(256.44, 450.65);
    path_3.close();

    Paint paint_3_fill = Paint()..style = PaintingStyle.fill;
    paint_3_fill.color = Color.fromRGBO(209, 233, 147, 1.0).withOpacity(1.0);
    canvas.drawPath(path_3, paint_3_fill);

    Path path_4 = Path();
    path_4.moveTo(256.44, 61.35);
    path_4.lineTo(256.44, 163.31);
    path_4.lineTo(177.88, 210.98);
    path_4.lineTo(88.28, 158.9);
    path_4.lineTo(256.44, 61.35);
    path_4.close();

    Paint paint_4_fill = Paint()..style = PaintingStyle.fill;
    paint_4_fill.color = Color.fromRGBO(128, 183, 250, 1.0).withOpacity(1.0);
    canvas.drawPath(path_4, paint_4_fill);

    Path path_5 = Path();
    path_5.moveTo(256.44, 61.35);
    path_5.lineTo(256.44, 163.31);
    path_5.lineTo(334.12, 210.98);
    path_5.lineTo(423.72, 158.9);
    path_5.lineTo(256.44, 61.35);
    path_5.close();

    Paint paint_5_fill = Paint()..style = PaintingStyle.fill;
    paint_5_fill.color = Color.fromRGBO(69, 129, 225, 1.0).withOpacity(1.0);
    canvas.drawPath(path_5, paint_5_fill);

    Path path_6 = Path();
    path_6.moveTo(340.74, 292.64);
    path_6.cubicTo(346.03, 297.93, 350.89, 308.52, 350.89, 316.91);
    path_6.cubicTo(350.89, 324.86, 346.03, 335.45, 340.74, 340.74);
    path_6.cubicTo(335.45, 346.03, 324.86, 350.89, 316.91, 350.89);
    path_6.cubicTo(308.52, 350.89, 297.93, 346.03, 292.64, 340.74);
    path_6.cubicTo(291.75, 339.86, 290.42, 338.54, 289.54, 336.77);
    path_6.cubicTo(289.99, 338.54, 289.99, 340.31, 289.99, 342.06);
    path_6.cubicTo(289.99, 350.02, 285.57, 360.6, 279.83, 365.9);
    path_6.cubicTo(274.54, 371.19, 264.39, 376.05, 256, 376.05);
    path_6.cubicTo(247.61, 376.05, 237.46, 371.19, 232.17, 365.9);
    path_6.cubicTo(226.43, 360.6, 222.01, 350.02, 222.01, 342.06);
    path_6.cubicTo(222.01, 340.31, 222.01, 338.54, 222.46, 337.21);
    path_6.cubicTo(221.13, 338.54, 220.25, 339.86, 219.36, 340.74);
    path_6.cubicTo(214.07, 346.03, 203.48, 350.89, 195.09, 350.89);
    path_6.cubicTo(186.71, 350.89, 176.55, 346.03, 171.26, 340.74);
    path_6.cubicTo(165.97, 335.45, 161.11, 324.86, 161.11, 316.91);
    path_6.cubicTo(161.11, 308.52, 165.97, 297.93, 171.26, 292.64);
    path_6.cubicTo(172.14, 291.75, 173.46, 290.42, 175.23, 289.54);
    path_6.cubicTo(173.46, 289.99, 171.69, 289.99, 169.94, 289.99);
    path_6.cubicTo(161.98, 289.99, 151.4, 285.57, 146.1, 279.83);
    path_6.cubicTo(140.81, 274.54, 135.95, 264.39, 135.95, 256);
    path_6.cubicTo(135.95, 247.61, 140.81, 237.46, 146.1, 232.17);
    path_6.cubicTo(151.4, 226.43, 161.98, 222.01, 169.94, 222.01);
    path_6.cubicTo(171.69, 222.01, 173.46, 222.01, 174.79, 222.46);
    path_6.cubicTo(173.46, 221.13, 172.14, 220.25, 171.26, 219.36);
    path_6.cubicTo(165.97, 214.07, 161.11, 203.48, 161.11, 195.09);
    path_6.cubicTo(161.11, 187.14, 165.97, 176.55, 171.26, 171.26);
    path_6.cubicTo(176.55, 165.97, 187.14, 161.11, 195.09, 161.11);
    path_6.cubicTo(203.48, 161.11, 214.07, 165.97, 219.36, 171.26);
    path_6.cubicTo(220.25, 172.14, 221.58, 173.46, 222.46, 175.23);
    path_6.cubicTo(222.01, 173.46, 222.01, 171.69, 222.01, 169.94);
    path_6.cubicTo(222.01, 161.98, 226.43, 151.4, 232.17, 146.1);
    path_6.cubicTo(237.46, 140.81, 247.61, 135.95, 256, 135.95);
    path_6.cubicTo(264.39, 135.95, 274.54, 140.81, 279.83, 146.1);
    path_6.cubicTo(285.57, 151.4, 289.99, 161.98, 289.99, 169.94);
    path_6.cubicTo(289.99, 171.69, 289.99, 173.46, 289.54, 174.79);
    path_6.cubicTo(290.87, 173.46, 291.75, 172.14, 292.64, 171.26);
    path_6.cubicTo(297.93, 165.97, 308.52, 161.11, 316.91, 161.11);
    path_6.cubicTo(324.86, 161.11, 335.45, 165.97, 340.74, 171.26);
    path_6.cubicTo(346.03, 176.55, 350.89, 187.14, 350.89, 195.09);
    path_6.cubicTo(350.89, 203.48, 346.03, 214.07, 340.74, 219.36);
    path_6.cubicTo(339.86, 220.25, 338.54, 221.58, 336.77, 222.46);
    path_6.cubicTo(338.54, 222.01, 340.31, 222.01, 342.06, 222.01);
    path_6.cubicTo(350.02, 222.01, 360.6, 226.43, 365.9, 232.17);
    path_6.cubicTo(371.19, 237.46, 376.05, 247.61, 376.05, 256);
    path_6.cubicTo(376.05, 264.39, 371.19, 274.54, 365.9, 279.83);
    path_6.cubicTo(360.6, 285.57, 350.02, 289.99, 342.06, 289.99);
    path_6.cubicTo(340.31, 289.99, 338.54, 289.99, 337.21, 289.54);
    path_6.cubicTo(338.54, 290.87, 339.86, 291.75, 340.74, 292.64);
    path_6.close();

    Paint paint_6_fill = Paint()..style = PaintingStyle.fill;
    paint_6_fill.color = Color.fromRGBO(47, 47, 47, 1.0).withOpacity(1.0);
    canvas.drawPath(path_6, paint_6_fill);

    Path path_7 = Path();
    path_7.moveTo(288.22, 269.25);
    path_7.lineTo(327.94, 269.25);
    path_7.cubicTo(331.47, 273.22, 336.32, 275.42, 342.06, 275.42);
    path_7.cubicTo(352.66, 275.42, 361.05, 266.59, 361.05, 256);
    path_7.cubicTo(361.05, 245.41, 352.66, 236.58, 342.06, 236.58);
    path_7.cubicTo(336.32, 236.58, 331.47, 239.23, 327.94, 242.75);
    path_7.lineTo(288.22, 242.75);
    path_7.lineTo(316.47, 214.51);
    path_7.cubicTo(316.47, 214.51, 316.47, 214.51, 316.91, 214.51);
    path_7.cubicTo(327.5, 214.51, 335.89, 205.68, 335.89, 195.09);
    path_7.cubicTo(335.89, 184.5, 327.5, 176.11, 316.91, 176.11);
    path_7.cubicTo(306.32, 176.11, 297.49, 184.5, 297.49, 195.09);
    path_7.cubicTo(297.49, 195.53, 297.49, 195.53, 297.49, 195.53);
    path_7.lineTo(269.25, 223.78);
    path_7.lineTo(269.25, 184.06);
    path_7.cubicTo(273.22, 180.53, 275.42, 175.68, 275.42, 169.94);
    path_7.cubicTo(275.42, 159.34, 266.59, 150.95, 256, 150.95);
    path_7.cubicTo(245.41, 150.95, 236.58, 159.34, 236.58, 169.94);
    path_7.cubicTo(236.58, 175.68, 239.23, 180.53, 242.75, 184.06);
    path_7.lineTo(242.75, 223.78);
    path_7.lineTo(214.51, 195.53);
    path_7.cubicTo(214.51, 195.53, 214.51, 195.53, 214.51, 195.09);
    path_7.cubicTo(214.51, 184.5, 206.13, 176.11, 195.09, 176.11);
    path_7.cubicTo(184.5, 176.11, 176.11, 184.5, 176.11, 195.09);
    path_7.cubicTo(176.11, 205.68, 184.5, 214.51, 195.09, 214.51);
    path_7.cubicTo(195.53, 214.51, 195.53, 214.51, 195.53, 214.51);
    path_7.lineTo(223.78, 242.75);
    path_7.lineTo(184.06, 242.75);
    path_7.cubicTo(180.53, 239.23, 175.68, 236.58, 169.94, 236.58);
    path_7.cubicTo(159.34, 236.58, 150.95, 245.41, 150.95, 256);
    path_7.cubicTo(150.95, 266.59, 159.34, 275.42, 169.94, 275.42);
    path_7.cubicTo(175.68, 275.42, 180.53, 273.22, 184.06, 269.25);
    path_7.lineTo(223.78, 269.25);
    path_7.lineTo(195.53, 297.49);
    path_7.cubicTo(195.53, 297.49, 195.53, 297.49, 195.09, 297.49);
    path_7.cubicTo(184.5, 297.49, 176.11, 305.87, 176.11, 316.91);
    path_7.cubicTo(176.11, 327.5, 184.5, 335.89, 195.09, 335.89);
    path_7.cubicTo(205.68, 335.89, 214.51, 327.5, 214.51, 316.91);
    path_7.cubicTo(214.51, 316.47, 214.51, 316.47, 214.51, 316.47);
    path_7.lineTo(242.75, 288.22);
    path_7.lineTo(242.75, 327.94);
    path_7.cubicTo(238.78, 331.47, 236.58, 336.32, 236.58, 342.06);
    path_7.cubicTo(236.58, 352.66, 245.41, 361.05, 256, 361.05);
    path_7.cubicTo(266.59, 361.05, 275.42, 352.66, 275.42, 342.06);
    path_7.cubicTo(275.42, 336.32, 272.77, 331.47, 269.25, 327.94);
    path_7.lineTo(269.25, 288.22);
    path_7.lineTo(297.49, 316.47);
    path_7.cubicTo(297.49, 316.47, 297.49, 316.47, 297.49, 316.91);
    path_7.cubicTo(297.49, 327.5, 305.87, 335.89, 316.91, 335.89);
    path_7.cubicTo(327.5, 335.89, 335.89, 327.5, 335.89, 316.91);
    path_7.cubicTo(335.89, 305.87, 327.5, 297.49, 316.91, 297.49);
    path_7.cubicTo(316.47, 297.49, 316.47, 297.49, 316.47, 297.49);
    path_7.lineTo(288.22, 269.25);
    path_7.close();

    Paint paint_7_fill = Paint()..style = PaintingStyle.fill;
    paint_7_fill.color = Color.fromRGBO(255, 255, 255, 1.0).withOpacity(1.0);
    canvas.drawPath(path_7, paint_7_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
