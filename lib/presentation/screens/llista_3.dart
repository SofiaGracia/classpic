import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xml_fotos/presentation/providers/alumne_notifier.dart';
import 'package:xml_fotos/presentation/providers/cursos_notifier.dart';
import 'package:xml_fotos/presentation/widgets/new_user.dart';
import 'package:xml_fotos/presentation/widgets/usuari_riverpod_ind.dart';

import '../../domain/entities/alumne.dart';
import '../../domain/entities/curs.dart';
import '../../domain/entities/professor.dart';
import '../../domain/models/usuari.dart';
import '../providers/provider_id.dart';
import '../providers/professor_notifier.dart';

class LlistaUsuarisR<T extends Usuari> extends ConsumerWidget {
  final bool isAlumne;
  final Curs? curs;
  final List<T>? initialLlista; // llista passada opcionalment

  const LlistaUsuarisR({
    super.key,
    required this.curs,
    required this.isAlumne,
    this.initialLlista,
  });

  String _getTitol(){
    return isAlumne? 'Alumnes de ${curs!.nom}': 'Professors';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final ids = isAlumne
        ? ref.watch(alumnesIdsProvider(curs!.id!))
        : ref.watch(professorsIdsProvider);

    // Llista actual que volem mostrar, o null si no tenim inicial
    List<T>? llista = initialLlista;

    final titol = _getTitol();

    // Si tenim llista passada però el tamany no coincideix amb ids, recarreguem
    if (llista == null || llista.length != ids.length) {
      return FutureBuilder<List<T>>(
        future: _carregaLlista<T>(ref, isAlumne, curs!.id!),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Scaffold(
                appBar: AppBar(
                  title: Text(titol),
                ),
                body:const Center(child: CircularProgressIndicator()),
            );
          }
          final novaLlista = snapshot.data!;

          return _buildScaffold(context, ref, novaLlista);
        },
      );
    } else {
      // Si la llista passada és vàlida i el tamany coincideix, no cal recarregar
      return _buildScaffold(context, ref, llista);
    }
  }

  Widget _buildScaffold(BuildContext context, WidgetRef ref, List<T> llista) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitol()),
      ),
      body: ListView(
        children: llista.map((usuari) {
          return UsuariWidgetRInd(
            usuari: usuari,
            onDelete: (u) async {
              if (u is Alumne) {
                await ref.read(alumnesNotifierProvider.notifier).eliminarAlumne(u);
              } else {
                await ref.read(professorNotifierProvider.notifier).eliminarProfessor(u as Professor);
              }
            },
          );
        }).toList(),
      ),
      floatingActionButton: NewUserR<Usuari>(
        onCreate: (u) async {
          if (u is Alumne) {
            await ref.read(alumnesNotifierProvider.notifier).inserirAlumne(u);
          } else {
            await ref.read(professorNotifierProvider.notifier).inserirProfessor(u as Professor);
          }
        },
        cursId: isAlumne? curs!.id! : null,
        getId: (u) => isAlumne ? (u as Alumne).nia : (u as Professor).dni,
        constructor: ({
          required String id,
          required String nom,
          required String c1,
          required String c2,
          String? fotoPath,
          String? fotoPathHash,
          String? grup,
        }) {
          if (isAlumne) {
            return Alumne(
              nia: id,
              nom: nom,
              c1: c1,
              c2: c2,
              fotoPath: fotoPath,
              fotoPathHash: fotoPathHash,
              grup: grup,
            );
          } else {
            return Professor(
              dni: id,
              nom: nom,
              c1: c1,
              c2: c2,
              fotoPath: fotoPath,
              fotoPathHash: fotoPathHash,
            );
          }
        },
        isAlumne: isAlumne,
      ),
    );
  }

  Future<List<T>> _carregaLlista<T extends Usuari>(
      WidgetRef ref, bool isAlumne, int? cursId) {
    if (isAlumne) {
      return ref
          .read(alumnesNotifierProvider.notifier)
          .getAlumnesPerCurs(cursId!) as Future<List<T>>;
    } else {
      return ref
          .read(professorNotifierProvider.notifier)
          .getProfessorsSenseModificarState() as Future<List<T>>;
    }
  }
}
