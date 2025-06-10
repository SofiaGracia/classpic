import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as image;

import '../../domain/models/qualitat_foto.dart';
import '../../domain/models/resolucio.dart';
import '../../shared/utils/guide_oval_painter.dart';
import '../providers/configuration_foto.dart';

class EditPhotoPage extends ConsumerStatefulWidget {
  final Uint8List imageBytes;

  const EditPhotoPage({super.key, required this.imageBytes});

  @override
  EditPhotoPageState createState() => EditPhotoPageState();
}

class EditPhotoPageState extends ConsumerState<EditPhotoPage> {
  // Aquí pots afegir controladors d'edició, si cal
  final GlobalKey _imageKey = GlobalKey();

  Future<Uint8List?> redimensionaIComprimeix({
    required File original,
    required Resolucio resolucio,
    int maxSizeKB = 90,
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

  Future<File?> _captureAndCrop() async {
    try {
      //El RepaintBoundary és com posar una "càmera" a un widget concret per a capturar només la seva visualització.
      RenderRepaintBoundary boundary =
      _imageKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

      // Captura una imatge del widget que està dins del RepaintBoundary.
      final cut = await boundary.toImage(pixelRatio: 3.0);

      // Converteix la imatge en memòria (ui.Image) a bytes binaris en format PNG.
      final byteData = await cut.toByteData(format: ui.ImageByteFormat.png);

      if (byteData == null) return null;

      //A partir de ByteData, extreu els bytes en forma de llista (Uint8List).
      // Representació directa de la imatge PNG que pots escriure en un fitxer o enviar per xarxa.
      final originalBytes = byteData.buffer.asUint8List();

      // Guarda la imatge en fitxer temporal
      final directory = await getTemporaryDirectory();
      final originalPath = '${directory.path}/original.png';
      final originalFile = File(originalPath)..writeAsBytesSync(originalBytes);

      // Defineix la resolució segons configuració de l’usuari
      final qualitat = ref.read(qualitatFotoProvider).value ?? QualitatFoto.mitjana;
      final resolucio = qualitat.resolucio;


      // Redimensiona i comprimeix
      final compressedBytes = await redimensionaIComprimeix(
        original: originalFile,
        resolucio: resolucio,
      );

      if (compressedBytes == null) return null;

      // Guarda la versió comprimida en un altre fitxer
      final outputPath = '${directory.path}/foto_retallada.jpg';
      final compressedFile = File(outputPath)..writeAsBytesSync(compressedBytes);

      return compressedFile;
    } catch (e) {
      debugPrint("Error retallant la imatge: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ajusta la Foto")),
      body: Stack(
        children: [
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child:RepaintBoundary(
                key: _imageKey,
                child: InteractiveViewer(
                  minScale: 1,
                  maxScale: 8,
                  child: Image.memory(widget.imageBytes),
                ),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height / 10,
            bottom: MediaQuery.of(context).size.height / 10,
            left: 0,
            right: 0,
            child: IgnorePointer(
              child: CustomPaint(
                painter: GuideOvalPainter(),
              ),
            )
          ),
          Positioned(
            bottom: 40,
            left: 40,
            right: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FloatingActionButton(
                  heroTag: "cancel",
                  backgroundColor: Colors.redAccent,
                  child: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context, null); // No guardem
                  },
                ),
                FloatingActionButton(
                  heroTag: "save",
                  backgroundColor: Colors.green,
                  child: const Icon(Icons.check),
                  onPressed: () async {
                    // Aquí podries afegir més tractament si cal (retall, ajust, etc.)
                    final result = await _captureAndCrop();
                    debugPrint('${result?.path}');
                    Navigator.pop(context, result); // Confirmem
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
