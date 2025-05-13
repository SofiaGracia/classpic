import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

import '../../shared/utils/guide_lines_painter.dart';
import '../../shared/utils/guide_oval_painter.dart';

class CameraPage extends StatefulWidget {
  final String pathPhoto;
  final String pathDir;

  const CameraPage({
    super.key,
    required this.pathPhoto,
    required this.pathDir,
  });

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final backCamera =
        cameras.firstWhere((c) => c.lensDirection == CameraLensDirection.back);

    _controller = CameraController(
      backCamera,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    _initializeControllerFuture = _controller!.initialize();
    setState(() {});
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _takeCompressedPicture() async {
    try {
      await _initializeControllerFuture;

      final XFile rawImage = await _controller!.takePicture();
      final File rawFile = File(rawImage.path);

      final bytes = await rawFile.readAsBytes();
      img.Image? image = img.decodeImage(bytes);

      if (image == null) throw Exception("No s'ha pogut llegir la imatge");

      // Redimensiona a 35x45 mm (aprox. 413x531 px a 300ppi)
      final resized = img.copyResize(
        image,
        width: 413,
        height: 531,
      );

      // Comprimeix en JPEG (ajusta qualitat si cal més compressió)
      final jpg = img.encodeJpg(resized,
          quality: 70); // Pots baixar més si supera els 100KB

      final outputFile = File(widget.pathPhoto);
      await outputFile.writeAsBytes(jpg);

      if (context.mounted) {
        Navigator.pop(context, outputFile);
      }
    } catch (e) {
      debugPrint("Error capturant/comprimint: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error capturant la imatge")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Captura de Foto")),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Reajustar la càmera a l'espai disponible
          return (_initializeControllerFuture == null)
              ? const Center(child: CircularProgressIndicator())
              : Stack(
                  children: [
                    FutureBuilder(
                      future: _initializeControllerFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Càmera ocupant tot l'ample disponible
                              Container(
                                width: double.infinity,
                                height: constraints.maxHeight *
                                    0.8, // 60% de l'altura
                                child: AspectRatio(
                                  aspectRatio: _controller!.value.aspectRatio,
                                  child: CameraPreview(_controller!),
                                ),
                              ),
                              const SizedBox(height: 20),
                              // Botó gran per capturar
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 40),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.camera_outlined,
                                    size: 50, // Mida de la icona
                                    color: Colors.grey, // Color de la icona
                                  ),
                                  onPressed: _takeCompressedPicture,
                                  iconSize: 80, // Mida més gran de la icona
                                ),
                              ),
                            ],
                          );
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      },
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.height / 10,
                      //height: MediaQuery.of(context).size.height,
                      bottom: MediaQuery.of(context).size.height / 10,
                      left: 0,
                      right: 0,
                      child: CustomPaint(
                        painter: GuideLinesPainter(),
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.height / 10,
                      //height: MediaQuery.of(context).size.height,
                      bottom: MediaQuery.of(context).size.height / 10,
                      left: 0,
                      right: 0,
                      child: CustomPaint(
                        painter: GuideOvalPainter(),
                      ),
                    ),
                  ],
                );
        },
      ),
    );
  }
}
