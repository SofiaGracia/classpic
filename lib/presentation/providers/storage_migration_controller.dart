import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:xml_fotos/shared/utils/constants.dart';
import '../../application/services/storage_service.dart';
import '../../data/repository/user.dart';
import '../../domain/models/user.dart';
import '../../shared/utils/dialog/delete.dart';
/*
enum StorageMigrationStatus {
  idle,
  loading,
  success,
  error,
}

class StorageMigrationState {
  final StorageMigrationStatus status;
  final String? message;

  const StorageMigrationState({
    this.status = StorageMigrationStatus.idle,
    this.message,
  });

  StorageMigrationState copyWith({
    StorageMigrationStatus? status,
    String? message,
  }) {
    return StorageMigrationState(
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }
}

final storageMigrationControllerProvider =
    NotifierProvider<StorageMigrationController, StorageMigrationState>(
  StorageMigrationController.new,
);

class StorageMigrationController extends Notifier<StorageMigrationState> {
  @override
  StorageMigrationState build() => const StorageMigrationState();

  Future<bool> changeDirectory(
      BuildContext context, DirectoriFotos? directori) async {
    state = state.copyWith(status: StorageMigrationStatus.loading);

    try {
      //Comprovem si tenim dades a la base de dades
      final hasPhotos = await hasUsersWithPhoto();
      final storage = ref.read(StorageServiceProvider);

      //Si no tenim fotos a la base de dades sols tenim que actualitzar la configuració del nou directori
      if (!hasPhotos) {
        await storage.guardaDirectoriSeleccionat(directori!);
        state = state.copyWith(status: StorageMigrationStatus.success);
        return true;
      }

      //Si sí que té fotos
      //Comprovem primer que el nou directori tinga dades
      final hasFiles = await newStorageHasFiles(directori!);
      if (!hasFiles) {
        //Si la nova carpeta no té dades preguntar de moure les fotos de la carpeta vella a la nova
        final moure = await showConfirmacioDialog(
          context: context,
          titol: 'Moure fotos',
          missatge:
              'El nou directori no té fotos. Moure les fotos al nou directori?',
          botoConfirmar: 'Sí, mou les fotos',
        );

        if (moure == true) {
          // 👇 Pots fer una funció `mouFotosAlNouDirectori()`
          try{
            await mouFotosAlNouDirectori(directori);
            await storage.guardaDirectoriSeleccionat(directori);
            state = state.copyWith(status: StorageMigrationStatus.success);
            return true;
          }catch (e){
            state = state.copyWith(status: StorageMigrationStatus.error);
            return false;
          }
        }
        await storage.guardaDirectoriSeleccionat(directori);
        state = state.copyWith(status: StorageMigrationStatus.success);
        return false;
      } else {
        final usarIgualment = await showConfirmacioDialog(
          context: context,
          titol: 'Atenció',
          missatge: '''
La carpeta de destí que has seleccionat ja conté fotos.

- Si la utilitzes igualment, NO es mouran les fotos antigues.
- Això pot provocar conflictes si hi ha fotos amb el mateix nom o fotos que no corresponen als usuaris actuals.

Què vols fer?
''',
          botoConfirmar: 'Sí, usar igualment',
          botoCancel: 'Cancel·lar',
        );

        if (usarIgualment == true) {
          await storage.guardaDirectoriSeleccionat(directori);
          state = state.copyWith(status: StorageMigrationStatus.success);
          return true;
        } else {
          state = state.copyWith(status: StorageMigrationStatus.idle);
          return false;
        }
      }
    } catch (e) {
      state = state.copyWith(
        status: StorageMigrationStatus.error,
        message: e.toString(),
      );
      return false;
    }
  }

  Future<void> mouFotosAlNouDirectori(DirectoriFotos directori) async {
    final usuarisAmbFotos = await getPhotoList();
    final storage = ref.read(StorageServiceProvider);
    final directoriActual = await storage.getBaseDirectory();
    final dirActualPath = directoriActual.path;
    final nouDirectoriBase = await storage.getDirectoryPath(directori);
    final nouDirBasePath = nouDirectoriBase.path;

    for (final usuari in usuarisAmbFotos) {
      final fotoFilename = usuari.fotoFilename;
      final pathAntic = '$dirActualPath/$fotoFilename';
      final fitxerAntic = File(pathAntic);
      final pathNou = '$nouDirBasePath/$fotoFilename';
      final fitxerNou = File(pathNou);

      try {
        final arxiuOriginal = File(pathAntic);

        if (!(await arxiuOriginal.exists())) {
          print('El fitxer original NO existeix!');
        }

        /*final carpetaDest = Directory('/storage/emulated/0/Pictures/ClassPic/Alumnes/4ESOC');

        if (!(await carpetaDest.exists())) {
          print('La carpeta destí NO existeix!');
        }*/
        final destDir = fitxerNou.parent;

        if (!(await destDir.exists())) {
          await destDir.create(recursive: true);
        }

        //await fitxerAntic.rename(pathNou);
        await fitxerAntic.copy(pathNou);
        await fitxerAntic.delete(recursive: true);
      } catch (e) {
        // Pla B: copy + delete
        await fitxerAntic.copy(pathNou);
        await fitxerAntic.delete();
      }
    }
  }



  Future<void> triaICreaDirectori() async {
    final uri = await StorageAccessFramework.openDocumentTree();
    if (uri != null) {
      print('Carpeta triada: $uri');
      // Desa aquest uri a SharedPreferences o Hive:
      // await preferences.setString('directoriTriat', uri);
    }
  }


  Future<List<Usuari>> getPhotoList() async {
    final repository = await ref.read(userRepositoryProvider.future);
    final alumnesList = await repository.getAlumnesWithPhoto();
    final professorsList = await repository.getProfessorsWithPhoto();
    final llista = [...alumnesList, ...professorsList];
    return llista;
  }

  Future<bool> hasUsersWithPhoto() async {
    final llista = await getPhotoList();
    return llista.isNotEmpty;
  }

  Future<bool> newStorageHasFiles(DirectoriFotos directori) async {
    final newStorageDir =
        await ref.read(StorageServiceProvider).getDirectoryPath(directori);
    final entities = await newStorageDir.list(recursive: true).toList();
    return entities.any((e) => e is File);
  }
}
*/