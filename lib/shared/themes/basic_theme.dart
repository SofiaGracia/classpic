import 'package:flutter/material.dart';
import 'package:xml_fotos/shared/themes/color_extension.dart';
import 'package:xml_fotos/shared/utils/constants.dart';

ThemeData getTheme(BuildContext context) {
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(100, 233, 226, 255)),
    brightness: Brightness.light,
    textTheme: TextTheme(
      titleLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: HexColor.fromHex('2D0C57'),
      ),
      bodyMedium: TextStyle(
        fontSize: 16,
        color: Colors.black87,
      ),
      labelSmall: TextStyle(
        fontSize: 12,
        fontStyle: FontStyle.italic,
        color: Colors.grey[700],
      ),
    ),
    //Widgets
    floatingActionButtonTheme:
        FloatingActionButtonThemeData(backgroundColor: defaultButtonColor),
    elevatedButtonTheme: getThemeElevatedButton(context, defaultButtonColor),
  );
}

//Put color to ElevatedButtons
ElevatedButtonThemeData getThemeElevatedButton(
    BuildContext context, Color color) {
  return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(backgroundColor: color));
}

//ElevatedButtons style
ButtonStyle getStyleElevatedButton(BuildContext context, Color color) {
  return ButtonStyle(
      backgroundColor:
      WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
    if (states.contains(WidgetState.pressed)) {
      return Theme.of(context).colorScheme.primary.withValues();
    }
    return color; // Use the component's default.
  }));
}
