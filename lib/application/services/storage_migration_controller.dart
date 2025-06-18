import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xml_fotos/application/services/storage_service.dart';
import 'package:xml_fotos/data/repository/user.dart';

import '../../shared/utils/dialog.dart';
/*
//Creem un provider de StorageMigrationController
final StorageMigrationControllerProvider = Provider<StorageMigrationController> ((ref) {
  return StorageMigrationController(ref);
});


class StorageMigrationController {

  final Ref ref;

  StorageMigrationController(this.ref);

  Future<bool> hasUsersWithPhoto() async {

    final repository = await ref.read(userRepositoryProvider.future);

    final alumnesCount = await repository.countAlumnesWithPhoto();
    final professorsCount = await repository.countProfessorsWithPhoto();
    return alumnesCount > 0 || professorsCount > 0;
  }

  Future<bool> changeDirectory(DirectoriFotos? directori) async {
    final hasPhotos = await hasUsersWithPhoto();
    final storage = ref.read(StorageServiceProvider);

    if (!hasPhotos) {
      // No hi ha fotos → canvia directori directament
      await storage.guardaDirectoriSeleccionat(directori!);
      return true;
    } else {
      // Sí hi ha fotos → mostra diàleg i segueix flux
      //await showConflictDialog();
      final hasFiles = await newStorageHasFiles(directori!);
      if(!hasFiles){
        //Preguntar de moure les foots del vell al nou
        final moure = await showConfirmacioEliminacioDialog(
          titol: 'Moure fotos',
          missatge: 'El nou directori no té fotos. Moure les fotos al nou directori?',
          botoConfirmar: 'Sí, mou les fotos'
        );

      }else{

      }
      return false;
    }
  }

  Future<bool> newStorageHasFiles(DirectoriFotos directori) async {
    try {
      final newStorageDir = await ref.read(StorageServiceProvider).getDirectoryPath(directori);
      final entities = await newStorageDir.list(recursive: true).toList();
      return entities.any((e) => e is File);
    } catch (e) {
      return false;
    }
  }
}*/