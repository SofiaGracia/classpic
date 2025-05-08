/*import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xml_fotos/models/alumne.dart';
import 'package:xml_fotos/utils/camera.dart';

import '../../models/usuari.dart';
import '../../service/storage_service.dart';
import '../../utils/constants.dart';

//
class UsuariTile extends ConsumerWidget {
  final Usuari usuari;
  final String identificador;
  final Uint8List? foto;
  final VoidCallback onEditar;
  final VoidCallback onEliminar;

  const UsuariTile({
    super.key,
    required this.usuari,
    required this.identificador,
    required this.onEditar,
    required this.onEliminar,
    this.foto,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            // Foto de l'usuari
            GestureDetector(
              onTap: () {
                debugPrint('HOLA');
              },
              /*onTap: () async {
                String pahtPhoto = '';
                String pathDir = '';
                if (usuari is Alumne) {
                  pahtPhoto = await ref.read(StorageServiceProvider).getPathAlumne((usuari as Alumne).grup!, usuari.nom);
                  pathDir = '$baseFolderName/$alumnesFolder/${(usuari as Alumne).grup}';
                }else{
                  pahtPhoto = await ref.read(StorageServiceProvider).getPathProfessor(usuari.nom);
                  pathDir = '$baseFolderName/$professorsFolder';
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CameraPage(
                      usuari: usuari,
                      pathPhoto: pahtPhoto,
                      pathDir: pathDir,
                    ),
                  ),
                );
              },*/
              child: CircleAvatar(
                radius: 30,
                backgroundImage: foto != null ? MemoryImage(foto!) : null,
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
                    '${usuari.c1} ${usuari.c2}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    usuari.nom,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    identificador,
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ],
              ),
            ),

            // Botons acció
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: onEditar,
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onEliminar,
            ),
          ],
        ),
      ),
    );
  }
}
*/