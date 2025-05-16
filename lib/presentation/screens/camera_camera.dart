import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

import '../../shared/utils/guide_lines_painter.dart';
import '../../shared/utils/guide_oval_painter.dart';
import 'edit_photo_page.dart';

// --- STATE ---
enum CameraStatus {
  initializing,
  ready,
  capturing,
  processing,
  editing,
}

class CameraState {
  final CameraStatus status;
  const CameraState(this.status);
}

class CameraStateNotifier extends StateNotifier<CameraState> {
  CameraStateNotifier() : super(const CameraState(CameraStatus.initializing));

  void setStatus(CameraStatus status) {
    state = CameraState(status);
  }
}

final cameraStateProvider =
StateNotifierProvider<CameraStateNotifier, CameraState>(
      (ref) => CameraStateNotifier(),
);

// --- UI ---
class CameraPage extends ConsumerStatefulWidget {
  final String pathPhoto;
  final String pathDir;

  const CameraPage({
    super.key,
    required this.pathPhoto,
    required this.pathDir,
  });

  @override
  ConsumerState<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends ConsumerState<CameraPage> {
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
    await _initializeControllerFuture;
    ref.read(cameraStateProvider.notifier).setStatus(CameraStatus.ready);
    setState(() {});
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _takeCompressedPicture() async {
    try {
      ref.read(cameraStateProvider.notifier).setStatus(CameraStatus.capturing);
      await _initializeControllerFuture;

      final XFile rawImage = await _controller!.takePicture();
      final File rawFile = File(rawImage.path);

      ref.read(cameraStateProvider.notifier).setStatus(CameraStatus.processing);

      final bytes = await rawFile.readAsBytes();
      img.Image? image = img.decodeImage(bytes);

      if (image == null) throw Exception("No s'ha pogut llegir la imatge");

      final resized = img.copyResize(
        image,
        width: 413,
        height: 531,
      );

      final jpg = img.encodeJpg(resized, quality: 30);

      final tempDir = await getTemporaryDirectory();
      final tempPath = '${tempDir.path}/temp_photo_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final tempFile = File(tempPath);
      await tempFile.writeAsBytes(jpg);
      //Acabar a que s'acabe de copiar
      //I també acabar a que s'acabe d'eliminar l'anterior pq si no a EditPhotoPage m'apareix la captura de la foto anterior que supose que
      //serà pq encara té eixe PhotoPath

      ref.read(cameraStateProvider.notifier).setStatus(CameraStatus.editing);

      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => EditPhotoPage(imageFile: tempFile),
        ),
      );

      if (result == true) {
        final outputFile = File(widget.pathPhoto);
        await tempFile.copy(outputFile.path);
        await tempFile.delete();
        Navigator.pop(context, outputFile);
      }

      ref.read(cameraStateProvider.notifier).setStatus(CameraStatus.ready);
    } catch (e) {
      debugPrint("Error capturant/comprimint: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error capturant la imatge")),
        );
      }
      ref.read(cameraStateProvider.notifier).setStatus(CameraStatus.ready);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cameraState = ref.watch(cameraStateProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Captura de Foto")),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (cameraState.status == CameraStatus.processing ||
              cameraState.status == CameraStatus.capturing) {
            return const Center(child: CircularProgressIndicator());
          }

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
                        Container(
                          width: double.infinity,
                          height: constraints.maxHeight * 0.8,
                          child: AspectRatio(
                            aspectRatio: _controller!.value.aspectRatio,
                            child: CameraPreview(_controller!),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 40),
                          child: IconButton(
                            icon: const Icon(
                              Icons.camera_outlined,
                              size: 50,
                              color: Colors.grey,
                            ),
                            onPressed: _takeCompressedPicture,
                            iconSize: 80,
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
                bottom: MediaQuery.of(context).size.height / 10,
                left: 0,
                right: 0,
                child: CustomPaint(
                  painter: GuideLinesPainter(),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height / 10,
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
