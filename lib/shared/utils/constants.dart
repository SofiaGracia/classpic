import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:xml_fotos/shared/themes/color_extension.dart';

const baseFolderName = 'ClassPic';
const alumnesFolder = 'Alumnes';
const professorsFolder = 'Professors';
const numNia = 8;
const numDni = 9;
const numMax = 10;
const grupSensenom = 'Sense grup';
const maxSizeKB = 90;
const cropCoverageRatio = 0.9;
const qualitatImatge = 90;
const keyFolder = 'folderUri';

const mesErrCreateFolder = "No s'ha creat la nova carpeta";

//Theme color
Color themeColor = Color.fromARGB(100, 233, 226, 255);

//Menu purple
Color menuBackground = HexColor.fromHex('A363F3');
Color topRightForm = Colors.deepPurple;
Color rightForm = Colors.purple;
Color bottomLeftForm = HexColor.fromHex('7E19FF');

//Elevated buttons
Color defaultButtonColor = HexColor.fromHex('FFBF59'); //Yellow

//Constants used for graphic effects
const pi = 3.14;
const strokeW = 240;