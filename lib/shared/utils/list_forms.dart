import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xml_fotos/shared/themes/color_extension.dart';

import 'constants.dart';
import 'decor_form.dart';

class ListForms extends StatelessWidget {
  final Size sizeScreen;

  const ListForms({super.key, required this.sizeScreen});

  @override
  Widget build(BuildContext context) {
    final firstC = CustomPaint(
      painter: DecorForm(
          sizeScreen: sizeScreen,
          rectWidth: 700,
          rectHeight: 700,
          rectLeftPosition: -675,
          rectTopPosition: -150,
          color: mainOrganic,
          strokeW: 240),
    );

    final secondC = CustomPaint(
      painter: DecorForm(
          sizeScreen: sizeScreen,
          rectWidth: 150,
          rectHeight: 150,
          rectLeftPosition: -280,
          rectTopPosition: -530,
          color: HexColor.fromHex('8529FA'),
          strokeW: 240),
    );

    return Stack(
      children: [
        Transform.rotate(angle: 6.59 * (pi / 4), child: firstC),
        Transform.rotate(angle: 6.7/pi, child: secondC),
      ],
    );
  }
}
