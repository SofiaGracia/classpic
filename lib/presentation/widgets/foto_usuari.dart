import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class FotoUsuariWidget extends StatelessWidget {
  final String? fotoPath;
  final String fotoPathHash; // Per forçar reconstrucció quan canviï
  final double radius;

  const FotoUsuariWidget({
    Key? key,
    required this.fotoPath,
    required this.fotoPathHash,
    this.radius = 30,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.grey.shade200,
      child: fotoPath != null
          ? FutureBuilder<Uint8List>(
        future: File(fotoPath!).readAsBytes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            return ClipOval(
              child: Image.memory(
                snapshot.data!,
                key: ValueKey(fotoPathHash),
                width: radius * 2,
                height: radius * 2,
                fit: BoxFit.cover,
              ),
            );
          } else {
            return const CircularProgressIndicator(strokeWidth: 2);
          }
        },
      )
          : const Icon(Icons.person),
    );
  }
}
