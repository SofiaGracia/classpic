import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xml_fotos/presentation/widgets/new_user.dart';
import 'package:xml_fotos/presentation/widgets/usuari_riverpod_ind.dart';

import '../../domain/entities/alumne.dart';
import '../../domain/entities/professor.dart';
import '../../domain/models/usuari.dart';
import '../providers/professor_notifier.dart';

class LlistaUsuarisR<T extends Usuari> extends ConsumerStatefulWidget {
  final bool isAlumne;

  const LlistaUsuarisR({
    super.key,
    required this.isAlumne,
  });

  @override
  ConsumerState<LlistaUsuarisR<T>> createState() => _LlistaUsuarisRState<T>();
}

class _LlistaUsuarisRState<T extends Usuari> extends ConsumerState<LlistaUsuarisR<T>> {
  List<T> _llista = [];

  @override
  void initState() {
    super.initState();
    _loadLlista();
  }

  Future<void> _loadLlista() async {
    if (widget.isAlumne) {
      // Carrega alumnes si ho implementes més endavant
    } else {
      final professors = await ref.read(professorNotifierProvider.notifier).getProfessorsSenseModificarState();
      setState(() {
        _llista = professors as List<T>;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Llista d’usuaris'),
      ),
      body: ListView(
        children: _llista.map((usuari) {
          return UsuariWidgetRInd(
            usuari: usuari,
            onDelete: (u) async {
              await ref.read(professorNotifierProvider.notifier).eliminarProfessor(u as Professor);
              setState(() {
                _loadLlista();
              });
            },
          );
        }).toList(),
      ),
      floatingActionButton: NewUserR<Usuari>(
        onCreate: (u) async {
          await ref.read(professorNotifierProvider.notifier).inserirProfessor(u as Professor);
          setState(() {
            _loadLlista();
          });
        },
        getId: (u) =>
        widget.isAlumne ? (u as Alumne).nia : (u as Professor).dni,
        constructor: ({
          required String id,
          required String nom,
          required String c1,
          required String c2,
          String? fotoPath,
          String? grup,
        }) {
          if (widget.isAlumne) {
            return Alumne(
              nia: id,
              nom: nom,
              c1: c1,
              c2: c2,
              fotoPath: fotoPath,
              grup: grup,
            );
          } else {
            return Professor(
              dni: id,
              nom: nom,
              c1: c1,
              c2: c2,
              fotoPath: fotoPath,
            );
          }
        },
        isAlumne: widget.isAlumne,
      ),
    );
  }
}
