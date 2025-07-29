import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:classpic/application/services/image_editing.dart';

import '../../domain/models/qualitat_foto.dart';
import '../../domain/models/resolucio.dart';
import '../../shared/utils/guide_oval_painter.dart';
import '../../shared/utils/guide_square.dart';
import '../providers/configuration_foto.dart';

class EditPhotoPage extends ConsumerStatefulWidget {
  final Uint8List imageBytes;
  final QualitatFoto qualitat;

  const EditPhotoPage(
      {super.key, required this.imageBytes, required this.qualitat});

  @override
  EditPhotoPageState createState() => EditPhotoPageState();
}

class EditPhotoPageState extends ConsumerState<EditPhotoPage> {
  // Aquí pots afegir controladors d'edició, si cal
  final GlobalKey _imageKey = GlobalKey();

  Future<Uint8List?> _captureAndCrop(double maxWidth, double maxHeight, double widthSq, double heightSq) async {
    try {
      //El RepaintBoundary és com posar una "càmera" a un widget concret per a capturar només la seva visualització.
      RenderRepaintBoundary boundary =
          _imageKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

      // Captura una imatge del widget que està dins del RepaintBoundary.
      final cut = await boundary.toImage(pixelRatio: 3.0);

      final croppedFile = await ImageEditingService.retalla(sizeMax: Size(maxWidth, maxHeight), sizeSq: Size(widthSq, heightSq), cut: cut);
      if(croppedFile == null) return null;

      //Obtenim la resolució
      final qualitat =
          ref.read(qualitatFotoProvider).value ?? QualitatFoto.mitjana;
      final resolucio = qualitat.resolucio;

      // Redimensiona i comprimeix
      final compressedBytes = await ImageEditingService.redimensionaIComprimeix(
        original: croppedFile,
        resolucio: resolucio,
      );
      if (compressedBytes == null) return null;

      // Guarda la versió comprimida en un altre fitxer
      /*final directory = await getTemporaryDirectory();
      final outputPath = '${directory.path}/foto_retallada.jpg';
      final compressedFile = File(outputPath)
        ..writeAsBytesSync(compressedBytes);*/

      //return compressedFile;
      return compressedBytes;
    } catch (e) {
      debugPrint("Error retallant la imatge: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Calcularem la relació d'aspecte de la resolució
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    final resolucio = widget.qualitat.resolucio;

    // Girem la resolució segons l'orientació
    final int amplada = isPortrait ? resolucio.alcada : resolucio.amplada;
    final int alcada = isPortrait ? resolucio.amplada : resolucio.alcada;

    final aspectRatio = amplada / alcada;

    return Scaffold(
        appBar: AppBar(title: const Text("Ajusta la Foto")),
        body: LayoutBuilder(builder: (context, constraints) {
          // Aquí calculem el màxim ample i alt per encaixar el marc dins la pantalla
          final maxWidth = constraints.maxWidth;
          final maxHeight = constraints.maxHeight;

          final maxWidthSq = maxWidth * 0.9; // 90% ample
          final maxHeightSq = maxHeight * 0.9; // 90% alt

          double widthSq, heightSq;

          if (maxWidthSq / maxHeightSq > aspectRatio) {
            // la limitació ve per alçada
            heightSq = maxHeightSq;
            widthSq = heightSq * aspectRatio;
          } else {
            // la limitació ve per amplada
            widthSq = maxWidthSq;
            heightSq = widthSq / aspectRatio;
          }

          return Stack(
            children: [
              Center(
                child: RepaintBoundary(
                  key: _imageKey,
                  child: InteractiveViewer(
                    minScale: 1,
                    maxScale: 8,
                    child: Image.memory(
                      widget.imageBytes,
                      width: maxWidth,
                      height: maxHeight,
                      //fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              Positioned(
                  top: 0,
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: IgnorePointer(
                    child: CustomPaint(
                      painter: GuideOvalPainter(),
                    ),
                  )),
              Positioned(
                  top: 0,
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: IgnorePointer(
                    child: CustomPaint(
                      painter: GuideSquarePainter(
                          widthSquare: widthSq,
                          heightSquare: heightSq,
                          widthShadow: maxWidth,
                          heightShadow: maxHeight),
                    ),
                  )),
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
                        final result = await _captureAndCrop(maxWidth, maxHeight, widthSq, heightSq);
                        Navigator.pop(context, result); // Confirmem
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        }));
  }
}
