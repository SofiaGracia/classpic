import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xml_fotos/presentation/providers/alu_widget.dart';

import '../../domain/entities/alumne.dart';
import '../../domain/entities/professor.dart';
import '../../domain/models/usuari.dart';
import '../../application/services/storage_service.dart';
import '../../shared/utils/constants.dart';
import '../../shared/utils/dialog.dart';
import '../providers/prof_widget.dart';
import '../screens/camera_camera.dart';
import '../screens/new_edit_user.dart';

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
          //isAlumne: widget.usuari is Alumne?,
          getId: (u) => u is Alumne ? u.nia : (u as Professor).dni,
          constructor: ({
            required String id,
            required String nom,
            required String c1,
            required String c2,
            String? fotoPath,
            String? grup
          }) {
            if (usuari is Alumne) {
              return Alumne(nia: id, nom: nom, c1: c1, c2: c2, grup: grup, fotoPath: fotoPath);
            } else {
              final professor = Professor(dni: id, nom: nom, c1: c1, c2: c2, fotoPath: fotoPath);
              return professor;
            }
          }, isAlumne: usuari is Alumne?,
        ),
      ),
    );
    final usuariARetornar;
    if (usuari is Alumne) {
      final alu = (nouUsuari as Alumne);
      usuariARetornar = (usuari).copyWith(id: usuari.id, nia: alu.nia, nom: alu.nom, c1: alu.c1 , c2: alu.c2, fotoPath: alu.fotoPath, grup: alu.grup);
    } else {
      final prof = (nouUsuari as Professor);
      usuariARetornar = (usuari as Professor).copyWith(id: usuari.id, dni: prof.dni, nom: prof.nom, c1: prof.c1 , c2: prof.c2, fotoPath: prof.fotoPath);
    }
    return usuariARetornar;
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('🔁 Rebuild UsuariWidgetR: ${widget.usuari.nom} ${widget.usuari.c1}');

    //final id = widget.usuari is Alumne? (widget.usuari as Alumne).id:(widget.usuari as Professor).id;
    //final usuariAsync = ref.watch(usuariNotifierProvider(id!));
    late final AsyncValue<Usuari> usuariAsync;
    late final dynamic provider;

    if(widget.usuari is Alumne){
      usuariAsync = ref.watch(alumneWidgetNotifierProvider((widget.usuari as Alumne).id!));
      provider = ref.read(alumneWidgetNotifierProvider((widget.usuari as Alumne).id!).notifier);
    }else{
      usuariAsync = ref.watch(professorWidgetNotifierProvider((widget.usuari as Professor).id!));
      provider = ref.read(professorWidgetNotifierProvider((widget.usuari as Professor).id!).notifier);
    }

    return usuariAsync.when(
      data: (usuari) => Card(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              // Foto de l'usuari
              GestureDetector(
                onTap: () async {
                  String pathPhoto = '';
                  String pathDir = '';
                  if (usuari is Alumne) {
                    pathPhoto = await ref.read(StorageServiceProvider).getPathAlumne(usuari.grup!, usuari.nom);
                    pathDir = '$baseFolderName/$alumnesFolder/${usuari.grup}';
                  }else{
                    pathPhoto = await ref.read(StorageServiceProvider).getPathProfessor(usuari!.nom);
                    pathDir = '$baseFolderName/$professorsFolder';
                  }
                  final File? novaFoto = await Navigator.push<File?>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CameraPage(
                        pathPhoto: pathPhoto,
                        pathDir: pathDir,
                      ),
                    ),
                  );
                  if (novaFoto != null) {
                    final actualitzat = usuari is Alumne? usuari.copyWith(fotoPath: novaFoto.path) : (usuari as Professor).copyWith(fotoPath: novaFoto.path);
                    provider.actualitza(actualitzat);
                  }
                },
                child: CircleAvatar(
                  radius: 30,
                  backgroundImage: usuari.fotoPath != null ? FileImage(File(usuari.fotoPath!)) : null,
                  child: usuari.fotoPath == null ? const Icon(Icons.person) : null,
                ),
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
                      '${usuari is Alumne? usuari.nia: (usuari as Professor).dni}',
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
                    if (actualitzat != null){
                      provider.actualitza(actualitzat);
                    }
                  }
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () async {
                  final confirmat = await showConfirmacioEliminacioDialog(
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
      ),
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
            children: [
              Expanded(child: Text('Error $e'))
            ],
          ),
        ),
      ),
    );
  }
}

    //final usuariP = ref.watch(usuariProvider(id!));
    //if (usuariP == null) return const CircularProgressIndicator();

    //final usuari = ref.watch(usuariLocalProvider(usuariP));

    /*return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            // Foto de l'usuari
            GestureDetector(
              onTap: () async {
                String pathPhoto = '';
                String pathDir = '';
                if (usuari is Alumne) {
                  pathPhoto = await ref.read(StorageServiceProvider).getPathAlumne(usuari.grup!, usuari.nom);
                  pathDir = '$baseFolderName/$alumnesFolder/${usuari.grup}';
                }else{
                  pathPhoto = await ref.read(StorageServiceProvider).getPathProfessor(usuari.nom);
                  pathDir = '$baseFolderName/$professorsFolder';
                }
                final File? novaFoto = await Navigator.push<File?>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CameraPage(
                      pathPhoto: pathPhoto,
                      pathDir: pathDir,
                    ),
                  ),
                );
                if (novaFoto != null) {
                  final actualitzat = usuari is Alumne? usuari.copyWith(fotoPath: novaFoto.path) : (usuari as Professor).copyWith(fotoPath: novaFoto.path);
                  ref.read(usuariLocalProvider(usuari).notifier).actualitza(actualitzat);
                }
              },
              child: CircleAvatar(
                radius: 30,
                backgroundImage: usuari.fotoPath != null ? FileImage(File(usuari.fotoPath!)) : null,
                child: usuari.fotoPath == null ? const Icon(Icons.person) : null,
              ),
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
                    '${usuari is Alumne? usuari.nia: (usuari as Professor).dni}',
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
                if (actualitzat != null){
                  ref.read(usuariLocalProvider(usuari).notifier).actualitza(actualitzat);
                }
              }
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () async {
                final confirmat = await showConfirmacioEliminacioDialog(
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
    );*/

