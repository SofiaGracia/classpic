import 'dart:io';
import 'dart:typed_data';
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
    int qualitat = 90;
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

  static Future<File?> processImageWithResolution({
    required Uint8List pngBytes,
    required int targetWidth,
    required int targetHeight,
    int maxSizeKB = maxSizeKB ,
  }) async {
    //Convertim ui.Image a image.Image
    final decodedImage = image.decodeImage(pngBytes);
    if (decodedImage == null) return null;

    //Mesures de la imatge
    final imageWidth = decodedImage.width;
    final imageHeight = decodedImage.height;

    //Calcular aspect ratio i mida de retall
    final aspectRatio = targetWidth / targetHeight;

    double widthCrop, heightCrop;

    if (imageWidth / imageHeight > aspectRatio) {
      // limita per alçada
      heightCrop = imageHeight * 0.9;
      widthCrop = heightCrop * aspectRatio;
    } else {
      widthCrop = imageWidth * 0.9;
      heightCrop = widthCrop / aspectRatio;
    }

    final x = ((imageWidth - widthCrop) / 2).round();
    final y = ((imageHeight - heightCrop) / 2).round();
    final cropWidth = widthCrop.round();
    final cropHeight = heightCrop.round();

    final cropped = image.copyCrop(
      decodedImage,
      width: cropWidth,
      height: cropHeight,
      x: x,
      y: y,
    );

    final jpgBytes = image.encodeJpg(cropped);

    // Guarda la imatge en fitxer temporal
    final directory = await getTemporaryDirectory();
    final originalPath = '${directory.path}/original.png';
    return File(originalPath)..writeAsBytesSync(jpgBytes);
  }
}