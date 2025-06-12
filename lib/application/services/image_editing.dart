import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:ui' as ui;
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image/image.dart' as image;
import 'package:path_provider/path_provider.dart';

import '../../domain/models/resolucio.dart';
import '../../shared/utils/constants.dart';

class ImageEditingService {
  static Future<Uint8List?> redimensionaIComprimeix({
    required File original,
    required Resolucio resolucio,
    int maxSizeKB = maxSizeKB,
  }) async {
    int qualitat = qualitatImatge;
    Uint8List? result;

    do {
      result = await FlutterImageCompress.compressWithFile(
        original.path,
        minWidth: resolucio.amplada,
        minHeight: resolucio.alcada,
        quality: qualitat,
        format: CompressFormat.jpeg,
      );

      if (result == null) return null;
      qualitat -= 10;
    } while (result.lengthInBytes > maxSizeKB * 1024 && qualitat > 20);

    return result;
  }

  static Future<File?> retalla(
      {required Size sizeMax, required Size sizeSq, required Image cut}) async {
    double maxWidth = sizeMax.width;
    double maxHeight = sizeMax.height;
    double widthSq = sizeSq.width;
    double heightSq = sizeSq.height;

    final imageWidth =
        cut.width; // amplada en píxels reals (multiplicat pel pixelRatio)
    final imageHeight = cut.height;

    final scaleX = imageWidth /
        maxWidth; // quants píxels reals per cada píxel UI horitzontal
    final scaleY = imageHeight /
        maxHeight; // quants píxels reals per cada píxel UI vertical

    final offsetX =
        (maxWidth - widthSq) / 2; // marge esquerra del marc en píxels UI
    final offsetY =
        (maxHeight - heightSq) / 2; // marge superior del marc en píxels UI

    final cropX = (offsetX * scaleX).round();
    final cropY = (offsetY * scaleY).round();

    final cropWidth = (widthSq * scaleX).round();
    final cropHeight = (heightSq * scaleY).round();

    final pngBytes = await cut.toByteData(format: ui.ImageByteFormat.png);
    final decodedImage = image.decodeImage(pngBytes!.buffer.asUint8List());
    if (decodedImage == null) return null;

    // Retalla amb image package
    final cropped = image.copyCrop(
      decodedImage,
      x: cropX,
      y: cropY,
      width: cropWidth,
      height: cropHeight,
    );

    final jpgBytes = image.encodeJpg(cropped);

    final directory = await getTemporaryDirectory();
    final croppedPath = '${directory.path}/cropped.jpg';
    final croppedFile = File(croppedPath)..writeAsBytesSync(jpgBytes);

    return croppedFile;
  }
}
