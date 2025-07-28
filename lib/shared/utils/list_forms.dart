import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xml_fotos/domain/models/shape_config.dart';
import 'package:xml_fotos/shared/utils/constants.dart';
import 'package:xml_fotos/shared/utils/decorative_form.dart';

class ListForms extends StatelessWidget {
  const ListForms({super.key});

  @override
  Widget build(BuildContext context) {
    final sizeScreen = MediaQuery.sizeOf(context);

    final shapes = [
      ShapeConfig(
          leftPosition: sizeScreen.width / 2,
          topPosition: sizeScreen.width / 2,
          sqrTop: 0,
          sqrLeft: sizeScreen.width / 2,
          color: topRightForm),
      ShapeConfig(
          leftPosition: (sizeScreen.width / 2) + 90,
          topPosition: (sizeScreen.width / 2) + 60,
          sqrTop: sizeScreen.width / 2,
          sqrLeft: (sizeScreen.width / 2) + 100,
          color: rightForm),
      ShapeConfig(
          leftPosition: (sizeScreen.width / 2) - 10,
          topPosition: (sizeScreen.width / 2) + 40,
          sqrTop: sizeScreen.width / 2,
          sqrLeft: 0,
          color: bottomLeftForm),
    ];

    return CustomPaint(
      painter: MultiDecorFormPainter(shapes: shapes, sizeScreen: sizeScreen),
    );
  }
}
