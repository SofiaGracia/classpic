import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:xml_fotos/presentation/providers/configuration_foto.dart';

import '../../shared/utils/guide_oval_painter.dart';
import 'edit_photo_page.dart';

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
  late File imageToSave;

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


      // 🔁 Detectar orientació de la càmera
      final orientation = _controller!.value.deviceOrientation;

      switch (orientation) {
        case DeviceOrientation.landscapeLeft:
          image = img.copyRotate(image, angle:  -90);
          break;
        case DeviceOrientation.landscapeRight:
          image = img.copyRotate(image,angle:  90);
          break;
        case DeviceOrientation.portraitDown:
          //image = img.copyRotate(image, angle:  180);
          break;
        case DeviceOrientation.portraitUp:
        default:
        // No fem res
          break;
      }

      final jpg = img.encodeJpg(image);

      ref.read(cameraStateProvider.notifier).setStatus(CameraStatus.editing);

      //Obtindre la resolució
      final servei = ref.read(configuracioFotoServiceProvider);
      final qualitat = await servei.carregaQualitat();

      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => EditPhotoPage(
            qualitat: qualitat,
              imageBytes:
                  Uint8List.fromList(jpg)), //Ací deuriem cridar a ImageCropper
        ),
      );

      if (result != null) {
        final outputFile = File(widget.pathPhoto);
        await result.copy(outputFile.path);
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
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    if (cameraState.status == CameraStatus.processing ||
        cameraState.status == CameraStatus.capturing) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Captura de Foto")),
      body: LayoutBuilder(builder: (context, constraints) {

        return FutureBuilder(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(child: CircularProgressIndicator());
              }

              final preview = Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    if (_controller == null ||
                        !_controller!.value.isInitialized) {
                      return const Center(
                          child: CircularProgressIndicator());
                    }

                    final size = constraints.biggest;
                    final previewSize = _controller!.value.previewSize!;
                    final screenAspectRatio = size.aspectRatio;
                    final previewAspectRatio =
                        previewSize.height / previewSize.width;

                    return Stack(
                      children: [
                        OverflowBox(
                          maxWidth: screenAspectRatio > previewAspectRatio
                              ? size.width
                              : size.height / previewAspectRatio,
                          maxHeight: screenAspectRatio > previewAspectRatio
                              ? size.width * previewAspectRatio
                              : size.height,
                          child: CameraPreview(_controller!),
                        ),
                        Positioned.fill(
                          child: CustomPaint(
                            painter: GuideOvalPainter(),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              );

              final captureButton = IconButton(
                icon: const Icon(Icons.camera_outlined,
                    size: 50, color: Colors.grey),
                onPressed: _takeCompressedPicture,
                iconSize: 80,
              );

              if (isPortrait) {
                return Column(
                  children: [
                    preview,
                    const SizedBox(height: 20),
                    captureButton,
                    const SizedBox(height: 20),
                  ],
                );
              } else {
                return Row(
                  children: [
                    Expanded(child: preview),
                    const SizedBox(width: 20),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        captureButton,
                      ],
                    ),
                    const SizedBox(width: 20),
                  ],
                );
              }
            });
      }),
    );
  }
}
