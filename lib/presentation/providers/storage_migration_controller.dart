import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xml_fotos/shared/utils/constants.dart';

import '../../application/services/storage_service.dart';
import '../../data/repository/user.dart';
import '../../shared/utils/dialog.dart';

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

  Future<void> changeDirectory(
      BuildContext context, DirectoriFotos? directori) async {
    state = state.copyWith(status: StorageMigrationStatus.loading);

    try {
      final hasPhotos = await hasUsersWithPhoto();
      final storage = ref.read(StorageServiceProvider);

      if (!hasPhotos) {
        await storage.guardaDirectoriSeleccionat(directori!);
        state = state.copyWith(status: StorageMigrationStatus.success);
        return;
      }

      final hasFiles = await newStorageHasFiles(directori!);
      if (!hasFiles) {
        final moure = await showConfirmacioEliminacioDialog(
          context: context,
          titol: 'Moure fotos',
          missatge:
              'El nou directori no té fotos. Moure les fotos al nou directori?',
          botoConfirmar: 'Sí, mou les fotos',
        );

        if (moure == true) {
          // 👇 Pots fer una funció `mouFotosAlNouDirectori()`
          await mouFotosAlNouDirectori(directori);
        }
      }

      // Marca com a èxit quan acabe tot
      state = state.copyWith(status: StorageMigrationStatus.success);
    } catch (e) {
      state = state.copyWith(
        status: StorageMigrationStatus.error,
        message: e.toString(),
      );
    }
  }

  Future<void> mouFotosAlNouDirectori(DirectoriFotos directori) async {
    final totesLesFotos = await getPhotoList();
    final storage = ref.read(StorageServiceProvider);
    final nouDirectoriBase = await storage.getDirectoryPath(directori);

    for (final fotoPath in totesLesFotos) {
      final foto = File(fotoPath);

      if (!await foto.exists()) continue;

      //Ostras clar he de canviar també el String fotoPath de cada alumne i Professor
      //per a que l'aplicació després trobe la foto.

      //si canvien el nom de baseFolderName no podré moure les fotos

      //Envoltar cada rename amb try/catch

      // Busca l'índex on comença "/ClassPic"
      final index = fotoPath.indexOf('$baseFolderName');
      if (index == -1) continue; // per seguretat

      // Obtén el subpath, per exemple: "/ClassPic/Professors/111111110.jpg"
      final subPath = fotoPath.substring(index);

      // Concatena el nou directori base amb el subPath
      final nouPath = '${nouDirectoriBase.path}$subPath';

      // Crea la carpeta de destí si no existeix
      final nouFitxer = File(nouPath);
      await nouFitxer.parent.create(recursive: true);

      // Mou la foto
      await foto.rename(nouFitxer.path);
    }
  }

  Future<List<String>> getPhotoList() async {
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
