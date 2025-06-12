import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../domain/models/resolucio.dart';

class CropFrameWidget extends StatelessWidget {
  final Resolucio resolucio;
  //final ImageProvider image;
  final Uint8List imageBytes;

  const CropFrameWidget({
    super.key,
    required this.resolucio,
    //required this.image,
    required this.imageBytes
  });

  @override
  Widget build(BuildContext context) {
    // Calcularem la relació d'aspecte de la resolució
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    // Girem la resolució segons l'orientació
    final int amplada = isPortrait ? resolucio.alcada : resolucio.amplada;
    final int alcada = isPortrait ? resolucio.amplada : resolucio.alcada;

    final aspectRatio = amplada / alcada;

    return LayoutBuilder(
      builder: (context, constraints) {
        // Aquí calculem el màxim ample i alt per encaixar el marc dins la pantalla
        final maxWidth = constraints.maxWidth * 0.9; // 90% ample
        final maxHeight = constraints.maxHeight * 0.9; // 90% alt

        double width, height;

        if (maxWidth / maxHeight > aspectRatio) {
          // la limitació ve per alçada
          height = maxHeight;
          width = height * aspectRatio;
        } else {
          // la limitació ve per amplada
          width = maxWidth;
          height = width / aspectRatio;
        }
        return Center(
          child: Stack(
            //alignment: Alignment.center,
            children: [
              InteractiveViewer(
                maxScale: 5,
                child: Image.memory(
                  imageBytes,
                  width: width,
                  height: height,
                  fit: BoxFit.contain,
                ),
              ),
              // Marc
              Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 3),
                  color: Colors.transparent,
                ),
              ),
              // Màscara fosca fora del marc
              /*Positioned.fill(
                child: IgnorePointer(
                  child: CustomPaint(
                    painter: _OverlayPainter(frameSize: Size(width, height)),
                  ),
                ),
              ),*/
            ],
          ),
        );
      },
    );
  }
}

class _OverlayPainter extends CustomPainter {
  final Size frameSize;

  _OverlayPainter({required this.frameSize});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black54
      ..style = PaintingStyle.fill;

    // Dibuixem tota la pantalla fosca
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    // I fem "transparent" el marc (clipping)
    final clipRect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: frameSize.width,
      height: frameSize.height,
    );

    // Com que Flutter no té clip "negative", fem servir BlendMode.clear
    canvas.saveLayer(Rect.fromLTWH(0, 0, size.width, size.height), Paint());
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
    final clearPaint = Paint()..blendMode = BlendMode.clear;
    canvas.drawRect(clipRect, clearPaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _OverlayPainter oldDelegate) {
    return oldDelegate.frameSize != frameSize;
  }
}
