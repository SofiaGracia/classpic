import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../shared/utils/guide_oval_painter.dart';

class EditPhotoPage extends StatefulWidget {
  final File imageFile;

  const EditPhotoPage({super.key, required this.imageFile});

  @override
  State<EditPhotoPage> createState() => _EditPhotoPageState();
}

class _EditPhotoPageState extends State<EditPhotoPage> {
  // Aquí pots afegir controladors d'edició, si cal

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ajusta la Foto")),
      body: Stack(
        children: [
          Center(
            child: InteractiveViewer( // per fer zoom i moure
              child: Image.file(widget.imageFile, key: ValueKey(widget.imageFile.path)),
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: GuideOvalPainter(), // o un marc d'ajust
              ),
            ),
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
                    Navigator.pop(context, false); // No guardem
                  },
                ),
                FloatingActionButton(
                  heroTag: "save",
                  backgroundColor: Colors.green,
                  child: const Icon(Icons.check),
                  onPressed: () {
                    // Aquí podries afegir més tractament si cal (retall, ajust, etc.)
                    debugPrint('${widget.imageFile}');
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${widget.imageFile}')),
                      );
                    });
                    Navigator.pop(context, true); // Confirmem
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
