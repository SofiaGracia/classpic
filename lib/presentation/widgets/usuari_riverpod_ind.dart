import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xml_fotos/application/services/saf_methods.dart';
import 'package:xml_fotos/domain/errors/import.dart';
import 'package:xml_fotos/presentation/providers/alu_widget.dart';
import 'package:xml_fotos/presentation/providers/uri_notifier.dart';
import 'package:xml_fotos/presentation/widgets/circ_usu.dart';
import 'package:xml_fotos/presentation/widgets/uri_dialog.dart';

import '../../domain/entities/alumne.dart';
import '../../domain/entities/professor.dart';
import '../../domain/models/usuari.dart';
import '../../application/services/storage_service.dart';
import '../../shared/utils/constants.dart';
import '../../shared/utils/dialog.dart';
import '../providers/prof_widget.dart';
import '../screens/camera_camera.dart';
import '../screens/new_edit_user.dart';
import 'foto_usuari.dart';

class UsuariWidgetRInd extends ConsumerStatefulWidget {
  final Usuari usuari;
  final Future<void> Function(Usuari usuari) onDelete;

  const UsuariWidgetRInd({
    super.key,
    required this.usuari,
    required this.onDelete,
  });

  @override
  ConsumerState<UsuariWidgetRInd> createState() => _UsuariWidgetRState();
}

class _UsuariWidgetRState extends ConsumerState<UsuariWidgetRInd> {
  Future<Usuari?> _editarUsuari(Usuari usuari) async {
    final nouUsuari = await Navigator.push<Usuari>(
      context,
      MaterialPageRoute(
        builder: (_) => NewEditUserScreen(
          usuari: usuari,
          getId: (u) => u is Alumne ? u.nia : (u as Professor).dni,
          constructor: (
              {required String id,
              required String nom,
              required String c1,
              required String c2,
              String? fotoFilename,
              String? fotoPathHash,
              String? grup}) {
            if (usuari is Alumne) {
              return Alumne(
                  nia: id,
                  nom: nom,
                  c1: c1,
                  c2: c2,
                  grup: grup,
                  fotoFilename: fotoFilename,
                  fotoPathHash: fotoPathHash,
                  fotoFolder: alumnesFolder);
            } else {
              final professor = Professor(
                  dni: id,
                  nom: nom,
                  c1: c1,
                  c2: c2,
                  fotoFilename: fotoFilename,
                  fotoPathHash: fotoPathHash,
                  fotoFolder: professorsFolder);
              return professor;
            }
          },
          isAlumne: usuari is Alumne?,
          cursId: usuari is Alumne ? usuari.cursId : null,
          codiUsuari: usuari is Alumne ? usuari.nia : (usuari as Professor).dni,
        ),
      ),
    );
    final usuariARetornar;
    if (usuari is Alumne) {
      final alu = (nouUsuari as Alumne);
      usuariARetornar = (usuari).copyWith(
        id: usuari.id,
        nia: alu.nia,
        nom: alu.nom,
        c1: alu.c1,
        c2: alu.c2,
        fotoFilename: alu.fotoFilename,
        fotoPathHash: alu.fotoPathHash,
        grup: alu.grup,
        cursId: alu.cursId,
      );
    } else {
      final prof = (nouUsuari as Professor);
      usuariARetornar = (usuari as Professor).copyWith(
        id: usuari.id,
        dni: prof.dni,
        nom: prof.nom,
        c1: prof.c1,
        c2: prof.c2,
        fotoFilename: prof.fotoFilename,
        fotoPathHash: prof.fotoPathHash,
      );
    }
    return usuariARetornar;
  }

  @override
  Widget build(BuildContext context) {
    late final AsyncValue<Usuari> usuariAsync;
    late final dynamic provider;

    if (widget.usuari is Alumne) {
      usuariAsync = ref
          .watch(alumneWidgetNotifierProvider((widget.usuari as Alumne).id!));

      provider = ref.read(
          alumneWidgetNotifierProvider((widget.usuari as Alumne).id!)
              .notifier); //Notifier individual per a alumne
    } else {
      usuariAsync = ref.watch(
          professorWidgetNotifierProvider((widget.usuari as Professor).id!));

      provider = ref.read(
          professorWidgetNotifierProvider((widget.usuari as Professor).id!)
              .notifier); //Notifier individual per a professor
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
                    onUpdate: (usu) => provider.actualitza(usu)
                ),
                const SizedBox(width: 12),
                // Dades del usuari
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${usuari.c1} ${usuari.c2}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        '${usuari.nom}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        '${usuari is Alumne ? usuari.nia : (usuari as Professor).dni}',
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
                        if (usuari is Alumne) {
                          /*ref.read(StorageServiceProvider).mouFotoAlumne(
                              usuari.grup!,
                              (actualitzat as Alumne).grup!,
                              actualitzat.nia);*/
                        }
                        provider.actualitza(actualitzat);
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
