import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as image;

import '../../shared/utils/quadrat_oval_painter.dart';

class EditPhotoPage extends StatefulWidget {
  //final File imageFile;
  //const EditPhotoPage({super.key, required this.imageFile});
  final Uint8List imageBytes;

  const EditPhotoPage({super.key, required this.imageBytes});

  @override
  State<EditPhotoPage> createState() => _EditPhotoPageState();
}

class _EditPhotoPageState extends State<EditPhotoPage> {
  // Aquí pots afegir controladors d'edició, si cal
  final GlobalKey _imageKey = GlobalKey();

  Future<File?> _captureAndCrop() async {
    try {
      RenderRepaintBoundary boundary =
      _imageKey.currentContext!.findRenderObject() as RenderRepaintBoundary; //El RepaintBoundary és com posar una "càmera" a un widget concret per a capturar només la seva visualització.
      final cut = await boundary.toImage(pixelRatio: 3.0);// Captura una imatge del widget que està dins del RepaintBoundary.
      final byteData = await cut.toByteData(format: ui.ImageByteFormat.png);// Converteix la imatge en memòria (ui.Image) a bytes binaris en format PNG.
      final pngBytes = byteData!.buffer.asUint8List();//A partir de ByteData, extreu els bytes en forma de llista (Uint8List). Representació directa de la imatge PNG que pots escriure en un fitxer o enviar per xarxa.


      //Amb decode i encode passem de una llista de ints en format png a la imatge com a tal
      //fa falta fer decoded si volem editar la imatge i després encoded per a tornar a passar-la a
      /*final decoded = image.decodePng(pngBytes);
      final resized = image.copyResize(decoded!, width: 100, height: 100);
      final encoded = image.encodePng(resized);
      File(outputPath)..writeAsBytesSync(encoded);*/

      //Per tant si vull comprimir la foto:
      final decoded = image.decodePng(pngBytes);
      final encoded = image.encodeJpg(decoded!, quality: 30);


      // Guarda la imatge en fitxer temporal
      final directory = await getTemporaryDirectory();
      final outputPath = '${directory.path}/foto_retallada.png';
      final file = File(outputPath)..writeAsBytesSync(encoded);
      return file;
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
            /*child: InteractiveViewer(
              minScale: 1,
              maxScale: 4,
              child: RepaintBoundary(
                key: _imageKey,
                child: Image.memory(widget.imageBytes),
              ),
            ),*/
            child: RepaintBoundary(
              key: _imageKey,
              child: InteractiveViewer(
                minScale: 1,
                maxScale: 4,
                child: Image.memory(widget.imageBytes),
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
                painter: GuideOvalSquarePainter(),
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
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${result}')),
                      );
                    });
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
