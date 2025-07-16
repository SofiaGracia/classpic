import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xml_fotos/application/services/saf_methods.dart';
import 'package:xml_fotos/domain/errors/import.dart';
import 'package:xml_fotos/presentation/providers/student/student.dart';
import 'package:xml_fotos/presentation/providers/uri_notifier.dart';
import 'package:xml_fotos/presentation/widgets/circ_usu.dart';
import 'package:xml_fotos/presentation/widgets/uri_dialog.dart';

import '../../domain/entities/student.dart';
import '../../domain/entities/teacher.dart';
import '../../domain/models/user.dart';
import '../../application/services/storage_service.dart';
import '../../shared/utils/constants.dart';
import '../../shared/utils/dialog.dart';
import '../providers/cursos_notifier.dart';
import '../providers/teacher/teacher.dart';
import '../screens/camera_camera.dart';
import '../screens/create_edit_user_screen.dart';
import 'foto_usuari.dart';

class UsuariWidgetRInd extends ConsumerStatefulWidget {
  final User usuari;
  final Future<void> Function(User usuari) onDelete;

  const UsuariWidgetRInd({
    super.key,
    required this.usuari,
    required this.onDelete,
  });

  @override
  ConsumerState<UsuariWidgetRInd> createState() => _UsuariWidgetRState();
}

class _UsuariWidgetRState extends ConsumerState<UsuariWidgetRInd> {
  var nomDelGrupActual = null;

  Future<User?> _editarUsuari(User usuari) async {
    final imageUser = usuari is Student
        ? await PlatformChannel.getFotoAlumneUri(usuari.group!, usuari.uId)
        : await PlatformChannel.getFotoProfessorUri(usuari.uId);

    if (usuari is Student) {
      final cursos = await ref
          .read(cursosNotifierProvider.notifier)
          .getCursosSenseModificarState();

      nomDelGrupActual = cursos
          .firstWhere((c) => c.id.toString() == usuari.courseId.toString())
          .name;
    }

    final nouUsuari = await Navigator.push<User>(
      context,
      MaterialPageRoute(
        builder: (_) => CreateEditUserScreen(
          usuari: usuari,
          isAlumne: usuari is Student?,
          cursId: usuari is Student ? usuari.courseId : null,
          cursNom: nomDelGrupActual,
          codiUsuari: usuari is Student ? usuari.nia : (usuari as Teacher).dni,
          uriImageUser: imageUser,
        ),
      ),
    );

    final usuariARetornar;
    if (usuari is Student) {
      final alu = (nouUsuari as Student);
      usuariARetornar = (usuari).copyWith(
        id: usuari.id,
        nia: alu.nia,
        name: alu.name,
        s1: alu.s1,
        s2: alu.s2,
        photoPathHash: alu.photoPathHash,
        hasFoto: alu.hasFoto,
        grup: alu.group,
        cursId: alu.courseId,
      );
    } else {
      final prof = (nouUsuari as Teacher);
      usuariARetornar = (usuari as Teacher).copyWith(
        id: usuari.id,
        dni: prof.dni,
        name: prof.name,
        s1: prof.s1,
        s2: prof.s2,
        hasFoto: prof.hasFoto,
        photoPathHash: prof.photoPathHash,
      );
    }
    return usuariARetornar;
  }

  @override
  Widget build(BuildContext context) {
    late final AsyncValue<User> usuariAsync;
    late final dynamic provider;

    if (widget.usuari is Student) {
      usuariAsync = ref
          .watch(studentWidgetNotifierProvider((widget.usuari as Student).id!));

      provider = ref.read(
          studentWidgetNotifierProvider((widget.usuari as Student).id!)
              .notifier); //Notifier individual per a student
    } else {
      usuariAsync = ref.watch(
          teacherWidgetNotifierProvider((widget.usuari as Teacher).id!));

      provider = ref.read(
          teacherWidgetNotifierProvider((widget.usuari as Teacher).id!)
              .notifier); //Notifier individual per a teacher
    }

    return usuariAsync.when(
      data: (usuari) {
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                // Foto de l'usuari
                CicleUser(
                    usuari: usuari,
                    onUpdate: (usu) => provider.updateUser(usu)),
                const SizedBox(width: 12),
                // Dades del usuari
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${usuari.s1} ${usuari.s2}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        '${usuari.name}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        '${usuari is Student ? usuari.nia : (usuari as Teacher).dni}',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ],
                  ),
                ),

                // Botons acció
                IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () async {
                      final actualitzat = await _editarUsuari(usuari);
                      if (actualitzat != null) {
                        provider.updateUser(actualitzat);
                      }
                    }),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    final confirmat = await showConfirmacioDialog(
                      context: context,
                      titol: 'Eliminar usuari',
                      missatge: 'Estàs segur que vols eliminar aquest usuari?',
                    );
                    if (confirmat == true) {
                      widget.onDelete(usuari);
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
      loading: () => Card(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              CircularProgressIndicator(),
            ],
          ),
        ),
      ),
      error: (e, _) => Card(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [Expanded(child: Text('Error $e'))],
          ),
        ),
      ),
    );
  }
}
