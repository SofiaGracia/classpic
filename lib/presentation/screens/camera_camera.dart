import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:image_cropper/image_cropper.dart';

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
  late File imageToSave;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  //Del paquet image_cropper: ^9.1.0
  /*Future<File?> retallaImatge(File imatgeOriginal) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: imatgeOriginal.path,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Retalla la imatge',
          toolbarColor: Colors.deepPurpleAccent,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
          aspectRatioPresets: [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9,
            //CropAspectRatioPresetCustom(),
          ],
          showCropGrid: true, // mostra graella per ajudar a retallar
          hideBottomControls: false, // mostra les opcions (rotar, flip, aspect ratio...)
          cropFrameStrokeWidth: 2,
          cropFrameColor: Colors.orange,
          cropGridColor: Colors.white,
          cropGridRowCount: 3,
          cropGridColumnCount: 3,
          activeControlsWidgetColor: Colors.orangeAccent,
        ),
      ],
    );

    if (croppedFile != null) {
      return File(croppedFile.path);
    } else {
      return null;
    }
  }*/

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

      final jpg = img.encodeJpg(resized);

      //Ací ja estic escrivint la imatge temp abans de retallar-la, això té sentit?
      /*final tempDir = await getTemporaryDirectory();
      final tempPath = '${tempDir.path}/temp_photo_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final tempFile = File(tempPath);
      await tempFile.writeAsBytes(jpg);*/

      ref.read(cameraStateProvider.notifier).setStatus(CameraStatus.editing);

      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => EditPhotoPage(
              imageBytes:
                  Uint8List.fromList(jpg)), //Ací deuriem cridar a ImageCropper
        ),
      );

      //Del paquet image_cropper: ^9.1.0
      //final result = await retallaImatge(tempFile);

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

    return Scaffold(
      appBar: AppBar(title: const Text("Captura de Foto")),
      body: LayoutBuilder(builder: (context, constraints) {
        final cameraState = ref.watch(cameraStateProvider);

        if (cameraState.status == CameraStatus.processing ||
            cameraState.status == CameraStatus.capturing) {
          return const Center(child: CircularProgressIndicator());
        }

        return FutureBuilder(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(child: CircularProgressIndicator());
              }

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
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
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: IconButton(
                      icon: const Icon(Icons.camera_outlined,
                          size: 50, color: Colors.grey),
                      onPressed: _takeCompressedPicture,
                      iconSize: 80,
                    ),
                  ),
                ],
              );
            });
      }),
    );

    /*return Scaffold(
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
                          /*child: AspectRatio(
                            aspectRatio: _controller!.value.aspectRatio,
                            child: CameraPreview(_controller!),
                          ),*/
                          child: Stack(
                            children: [
                              AspectRatio(
                                aspectRatio: _controller!.value.aspectRatio,
                                child: CameraPreview(_controller!),
                              ),
                              Positioned.fill(
                                child: CustomPaint(
                                  painter: GuideOvalPainter(),
                                ),
                              ),
                            ],
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
              /*Positioned(
                top: MediaQuery.of(context).size.height / 10,
                bottom: MediaQuery.of(context).size.height / 10,
                left: 0,
                right: 0,
                child: CustomPaint(
                  painter: GuideOvalPainter(),
                ),
              ),*/
            ],
          );
        },
      ),
    );*/
  }
}
