import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xml_fotos/screens/widgets/new_user.dart';
import 'package:xml_fotos/screens/widgets/usuari_riverpod.dart';

import '../models/alumne.dart';
import '../models/professor.dart';
import '../models/usuari.dart';
import '../providers/alumne_notifier.dart';

class LlistaUsuarisR<T extends Usuari> extends ConsumerWidget {
  //final int? cursId;
  final ProviderListenable<AsyncValue<List<T>>> provider;
  final Future<void> Function(T usuari) onEditar;
  final Future<void> Function(T usuari) onBorrar;
  //Ací deuriem tindre un onCreate;
  final Future<void> Function(T usuari) onCreate;

  const LlistaUsuarisR({
    super.key,
    //this.cursId,
    required this.provider,
    required this.onEditar,
    required this.onBorrar,
    required this.onCreate
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncValue = ref.watch(provider);

    return Scaffold(
      appBar: AppBar(
        title: Text('llista'),
      ),
      body: asyncValue.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (llista) {
          return ListView(
            children: llista.map((usuari) {
              return UsuariWidgetR(
                usuari: usuari,
                onEditar: (u) => onEditar(u as T),
                onBorrar: (u) => onBorrar(u as T),
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: NewUserR<T>(
        onCreate: (u) => onCreate(u as T),
        getId: (u) => T == Alumne ? (u as Alumne).nia: (u as Professor).dni,
        constructor: ({
          required String id,
          required String nom,
          required String c1,
          required String c2,
          String? fotoPath,
          String? grup
        }) {
          if (T == Alumne) {
            return Alumne(nia: id, nom: nom, c1: c1, c2: c2, fotoPath: fotoPath, grup: grup) as T;
          } else {
            return Professor(dni: id, nom: nom, c1: c1, c2: c2, fotoPath: fotoPath) as T;
          }
        }, isAlumne: T == Alumne,
      ),
    );
  }
}
