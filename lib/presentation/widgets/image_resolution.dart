import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/qualitat_foto.dart';
import '../../domain/models/resolucio.dart';
import '../providers/configuration_foto.dart';

class ImageResolutionWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final qualitatAsync = ref.watch(qualitatFotoProvider);

    return qualitatAsync.when(
      data: (qualitatSeleccionada) {
        return DropdownButton<QualitatFoto>(
          value: qualitatSeleccionada,
          items: QualitatFoto.values.map((qualitat) {
            final r = resolucioPerQualitat(qualitat);
            return DropdownMenuItem(
              value: qualitat,
              child: Text('${qualitat.name.toUpperCase()} (${r.amplada}x${r.alcada})'),
            );
          }).toList(),
          onChanged: (novaQualitat) async {
            if (novaQualitat != null) {
              final servei = ref.read(configuracioFotoServiceProvider);
              await servei.guardaQualitat(novaQualitat);
              ref.invalidate(qualitatFotoProvider); // Torna a carregar
            }
          },
        );
      },
      loading: () => CircularProgressIndicator(),
      error: (e, _) => Text('Error: $e'),
    );
  }
}


