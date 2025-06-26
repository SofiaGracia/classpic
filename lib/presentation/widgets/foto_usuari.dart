import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../application/services/saf_methods.dart';

class FotoUsuariWidget extends StatelessWidget {
  final Uri? uri;
  final String fotoPathHash; // Per forçar reconstrucció quan canviï
  final double radius;

  const FotoUsuariWidget({
    Key? key,
    required this.uri,
    required this.fotoPathHash,
    this.radius = 30,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.grey.shade200,
      child: uri != null
          ? FutureBuilder<Uint8List?>(
        future: PlatformChannel.readBytesFromSafUri(uri!),
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
