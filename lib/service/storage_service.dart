import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

final StorageServiceProvider = Provider<StorageService>((ref) {
  return StorageService();
});

class StorageService {
  static const _baseFolderName = 'ClassPic';
  static const _alumnesFolder = 'Alumnes';
  static const _professorsFolder = 'Professors';

  /// Obté el directori base de l’aplicació a l’emmagatzematge extern
  Future<Directory> _getBaseDirectory() async {
    final extDir = await getExternalStorageDirectory();
    final appDir = Directory('${extDir?.path}/$_baseFolderName');

    if (!await appDir.exists()) {
      await appDir.create(recursive: true);
    }
    return appDir;
  }

  /// Crea l’estructura inicial per als alumnes (un directori per curs)
  Future<void> creaEstructuraAlumnes(Set<String> nomsCursos) async {
    final baseDir = await _getBaseDirectory();
    final alumnesDir = Directory('${baseDir.path}/$_alumnesFolder');

    if (!await alumnesDir.exists()) {
      await alumnesDir.create();
    }

    for (final nomCurs in nomsCursos) {
      final cursDir = Directory('${alumnesDir.path}/$nomCurs');
      if (!await cursDir.exists()) {
        await cursDir.create(recursive: true);
      }
    }
  }

  /// Crea la carpeta base de professors si no existeix
  Future<void> creaEstructuraProfessors() async {
    final baseDir = await _getBaseDirectory();
    final professorsDir = Directory('${baseDir.path}/$_professorsFolder');

    if (!await professorsDir.exists()) {
      await professorsDir.create(recursive: true);
    }
  }

  /// Obté el path de la carpeta d’un alumne concret
  Future<String> getPathAlumne(String nomCurs, String nomAlumne) async {
    final baseDir = await _getBaseDirectory();
    return '${baseDir.path}/$_alumnesFolder/$nomCurs/$nomAlumne.jpg';
  }

  /// Obté el path de la foto d’un professor concret
  Future<String> getPathProfessor(String nomProfessor) async {
    final baseDir = await _getBaseDirectory();
    return '${baseDir.path}/$_professorsFolder/$nomProfessor.jpg';
  }

  Future<void> eliminaCarpetesAlumnes(Set<String> nomsCursos) async {
    final baseDir = await _getBaseDirectory();
    final alumnesDir = Directory('${baseDir.path}/$_alumnesFolder');

    for (final nomCurs in nomsCursos) {
      final cursDir = Directory('${alumnesDir.path}/$nomCurs');
      if (await cursDir.exists()) {
        await cursDir.delete(recursive: true);
      }
    }
  }

  Future<void> mouFotoAlumne(String nomCursVell, String nomCursNou, String nomAlumne) async {
    final baseDir = await _getBaseDirectory();

    final origen = File('${baseDir.path}/$_alumnesFolder/$nomCursVell/$nomAlumne.jpg');
    final destiDir = Directory('${baseDir.path}/$_alumnesFolder/$nomCursNou');

    if (!await destiDir.exists()) {
      await destiDir.create(recursive: true);
    }

    final desti = File('${destiDir.path}/$nomAlumne.jpg');

    if (await origen.exists()) {
      await origen.rename(desti.path);
    }
  }
}
