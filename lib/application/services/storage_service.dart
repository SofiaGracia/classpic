import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../presentation/providers/uri_notifier.dart';
import '../../shared/utils/constants.dart';

final StorageServiceProvider = Provider<StorageService>((ref) {
  return StorageService(ref);
});

class StorageService {
  final Ref ref;

  StorageService(this.ref);

  Future<String> getBaseDirectory() async {
    final dirBase = await ref.read(uriProvider.notifier).getUri();
    if (dirBase == null) {
      throw Exception("No directory selected");
    }
    return dirBase;
  }

  /// Obté el path de la carpeta d’un alumne concret
  Future<String> getPathAlumne(String nomCurs, String niaAlumne) async {
    final baseDir = await getBaseDirectory();
    return '$baseDir/$alumnesFolder/$nomCurs/$niaAlumne.jpg';
  }

  /// Obté el path de la foto d’un professor concret
  Future<String> getPathProfessor(String nomProfessor) async {
    final baseDir = await getBaseDirectory();
    return '$baseDir/$professorsFolder/$nomProfessor.jpg';
  }

  Future<String> getDirAlumne(String nomCurs, String nomAlumne) async {
    final baseDir = await getBaseDirectory();
    return '$baseDir/$alumnesFolder/$nomCurs';
  }

  /// Obté el path de la foto d’un professor concret
  Future<String> getDirProfessor(String nomProfessor) async {
    final baseDir = await getBaseDirectory();
    return '$baseDir/$professorsFolder';
  }

  Future<void> eliminaFoto(String fotoPath) async {
    final foto = File(fotoPath);
    if (await foto.exists()) {
      await foto.delete();
    }
  }

  Future<void> eliminaFotos(List<String> paths) async {
    await Future.wait(paths.map((path) => eliminaFoto(path)));
  }
}
