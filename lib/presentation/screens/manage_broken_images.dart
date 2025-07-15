import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/broken_images.dart';

/// Provider per saber quins usuaris ha seleccionat l'usuari
final usuarisSeleccionatsProvider = StateProvider<Set<int>>((ref) => {});

/// Opcions d'acció possibles
enum AccioFotos { esborraReferencia, esborraUsuari }

final accioSeleccionadaProvider = StateProvider<AccioFotos>((ref) => AccioFotos.esborraReferencia);

class GestioFotosTrencadesScreen extends ConsumerWidget {
  const GestioFotosTrencadesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usuaris = ref.watch(fotosTrencadesProvider);
    final seleccionats = ref.watch(usuarisSeleccionatsProvider);
    final accio = ref.watch(accioSeleccionadaProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Gestió de fotos trencades')),
      body: Column(
        children: [
          const SizedBox(height: 8),
          Text('${usuaris.length} usuaris amb fotos trencades', style: Theme.of(context).textTheme.titleMedium),
          const Divider(),
          Expanded(
            child: ListView(
              children: usuaris.map((usuari) {
                final seleccionat = seleccionats.contains(usuari.idDB);
                return CheckboxListTile(
                  value: seleccionat,
                  title: Text(usuari.nom),
                  subtitle: const Text('Foto no trobada'),
                  onChanged: (_) {
                    ref.read(usuarisSeleccionatsProvider.notifier).update((set) {
                      final nou = {...set};
                      if (seleccionat) {
                        nou.remove(usuari.idDB);
                      } else {
                        nou.add(usuari.idDB!);
                      }
                      return nou;
                    });
                  },
                );
              }).toList(),
            ),
          ),
          const Divider(),
          ListTile(
            title: const Text('Esborra només les referències'),
            leading: Radio<AccioFotos>(
              value: AccioFotos.esborraReferencia,
              groupValue: accio,
              onChanged: (value) => ref.read(accioSeleccionadaProvider.notifier).state = value!,
            ),
          ),
          ListTile(
            title: const Text('Esborra els usuaris completament'),
            leading: Radio<AccioFotos>(
              value: AccioFotos.esborraUsuari,
              groupValue: accio,
              onChanged: (value) => ref.read(accioSeleccionadaProvider.notifier).state = value!,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel·la'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () async {
                    final seleccionats = ref.read(usuarisSeleccionatsProvider);
                    final accio = ref.read(accioSeleccionadaProvider);
                    final usuaris = ref.read(fotosTrencadesProvider);

                    final perTractar = usuaris.where((u) => usuaris.contains(u.idDB)).toList();

                    if (accio == AccioFotos.esborraReferencia) {
                      // TODO: cridar repositori o servei per actualitzar usuaris
                      // perTractar.forEach((u) => db.updateUsuari(u.senseFoto()));
                    } else {
                      // TODO: eliminar usuaris del sistema
                      // perTractar.forEach((u) => db.deleteUsuari(u.id));
                    }

                    Navigator.of(context).pop();
                  },
                  child: const Text('Aplica'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}