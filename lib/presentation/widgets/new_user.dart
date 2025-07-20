import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xml_fotos/presentation/providers/cursos_notifier.dart';
import 'package:xml_fotos/presentation/providers/student/repository.dart';
import 'package:xml_fotos/presentation/providers/teacher/repository.dart';

import '../../application/services/codi_generator.dart';
import '../../domain/models/user.dart';
import '../screens/create_edit_user_screen.dart';

class NewUserR<T extends User> extends ConsumerWidget {
  final bool isAlumne;
  final Future<void> Function(User usuari) onCreate;
  final int? cursId;
  final String Function(T usuari) getId;

  NewUserR({
    super.key,
    required this.isAlumne,
    required this.onCreate,
    required this.cursId,
    required this.getId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FloatingActionButton(
      onPressed: () async {
        final codiUsuari = await CodiGenerator.generaCodi(
            isAlumne: isAlumne,
            existeixFunc: (codi) async {
              return isAlumne
                  ? await ref
                      .read(studentRepositoryProvider).findStudentByNia(codi) != null
                  :
              await ref.read(teacherRepositoryProvider).carregaProfessorDBbyDni(codi) != null;
            });

        var nomDelGrupActual = null;

        if (isAlumne){

          final cursos = await ref.read(cursosNotifierProvider.notifier).getCursosSenseModificarState();

          nomDelGrupActual = cursos
              .firstWhere((c) => c.id.toString() == cursId.toString())
              .name;
        }

        final nouUsuari = await Navigator.push<User>(
          context,
          MaterialPageRoute(
            builder: (_) => CreateEditUserScreen<T>(
              usuari: null,
              isAlumne: isAlumne,
              cursId: isAlumne? cursId: null,
              cursNom: nomDelGrupActual,
              codiUsuari: codiUsuari,
              uriImageUser: null,
            ),
          ),
        );

        if (nouUsuari != null) {
          await onCreate(nouUsuari);
        }
      },
      child: const Icon(Icons.add),
      tooltip: 'Afegir usuari',
    );
  }
}
