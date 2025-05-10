import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/alumne.dart';
import '../../models/professor.dart';
import '../../models/usuari.dart';
import '../../service/storage_service.dart';
import '../../utils/constants.dart';
import '../camera_camera.dart';
import '../new_edit_user.dart';

class UsuariWidgetR extends ConsumerStatefulWidget {
  //final int usuariId;
  final Usuari usuari;
  final Future<void> Function(Usuari usuari) onEditar;
  final Future<void> Function(Usuari usuari) onBorrar;

  const UsuariWidgetR({
    super.key,
    required this.usuari,
    required this.onEditar,
    required this.onBorrar,
  });

  @override
  ConsumerState<UsuariWidgetR> createState() => _UsuariWidgetRState();
}

class _UsuariWidgetRState extends ConsumerState<UsuariWidgetR> {

  Future<void> _borrarUsuari() async {
    await widget.onBorrar(widget.usuari);
  }

  Future<void> _editarUsuari() async {
    final nouUsuari = await Navigator.push<Usuari>(
      context,
      MaterialPageRoute(
        builder: (_) => NewEditUserScreen(
          usuari: widget.usuari,
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
            if (widget.usuari is Alumne) {
              return Alumne(nia: id, nom: nom, c1: c1, c2: c2, fotoPath: fotoPath, grup: grup);
            } else {
              return Professor(dni: id, nom: nom, c1: c1, c2: c2, fotoPath: fotoPath);
            }
          }, isAlumne: widget.usuari is Alumne?,
        ),
      ),
    );

    if (nouUsuari != null) {
      await widget.onEditar(nouUsuari);
    }
  }

  @override
  Widget build(BuildContext context) {

    final foto = widget.usuari.fotoPath;

    return Card(
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
                if (widget.usuari is Alumne) {
                  pathPhoto = await ref.read(StorageServiceProvider).getPathAlumne((widget.usuari as Alumne).grup!, widget.usuari.nom);
                  pathDir = '$baseFolderName/$alumnesFolder/${(widget.usuari as Alumne).grup}';
                }else{
                  pathPhoto = await ref.read(StorageServiceProvider).getPathProfessor(widget.usuari.nom);
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
                  final nouUsuari = widget.usuari is Alumne
                      ? (widget.usuari as Alumne).copyWith(fotoPath: novaFoto.path)
                      : (widget.usuari as Professor).copyWith(fotoPath: novaFoto.path);

                  await widget.onEditar(nouUsuari);
                }
              },
              child: CircleAvatar(
                radius: 30,
                backgroundImage: foto != null ? FileImage(File(foto)) : null,
                child: foto == null ? const Icon(Icons.person) : null,
              ),
            ),
            const SizedBox(width: 12),
            // Dades del usuari
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${widget.usuari.c1} ${widget.usuari.c2}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    '${widget.usuari.nom}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    '${widget.usuari is Alumne? (widget.usuari as Alumne).nia: (widget.usuari as Professor).dni}',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ],
              ),
            ),

            // Botons acció
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: _editarUsuari,
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: _borrarUsuari,
            ),
          ],
        ),
      ),
    );
  }
}
