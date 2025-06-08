import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../shared/utils/constants.dart';

enum DirectoriFotos {
  intern, // Android/data/...
  pictures, // /Pictures/ClassPic
  dcim, // /DCIM/ClassPic
}

final StorageServiceProvider = Provider<StorageService>((ref) {
  return StorageService();
});

class StorageService {

  //Guardar la configuració a SharedPreferences
  Future<void> guardaDirectoriSeleccionat(DirectoriFotos directori) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('directori_fotos', directori.name);
  }

  Future<DirectoriFotos> carregaDirectoriSeleccionat() async {
    final prefs = await SharedPreferences.getInstance();
    final valor = prefs.getString('directori_fotos') ?? 'intern';
    return DirectoriFotos.values.firstWhere((e) => e.name == valor);
  }

  /// Obté el directori base de l’aplicació a l’emmagatzematge extern
  Future<Directory> _getBaseDirectory() async {
    final directori = await carregaDirectoriSeleccionat();
    Directory base;

    switch (directori) {
      case DirectoriFotos.pictures:
        base = Directory('/storage/emulated/0/Pictures');
        break;
      case DirectoriFotos.dcim:
        base = Directory('/storage/emulated/0/DCIM');
        break;
      default:
        final extDir = await getExternalStorageDirectory(); // Android/data/...
        base = Directory('${extDir?.path}');
        break;
    }
    final appDir = Directory('${base.path}/$baseFolderName');
    if (!await appDir.exists()) {
      await appDir.create(recursive: true);
    }
    return appDir;
  }

  /// Obté el directori base de l’aplicació a l’emmagatzematge extern
  Future<Directory?> _getDirPictures() async {
    try {
      final extDir = Directory('/storage/emulated/0/DCIM');
      if (!await extDir.exists()) {
        await extDir.create(recursive: true);
      }
      final appDir = Directory('${extDir.path}/$baseFolderName');

      if (!await appDir.exists()) {
        await appDir.create(recursive: true);
      }

      return appDir;
    } catch (e, st) {
      debugPrintStack(label: '$e  $st');
    }
    return null;
  }

  Future<void> creaEstructuraInicial() async {
    await creaEstructuraProfessors();
    await creaEstructuraAlumnes(null);
  }

  /// Crea l’estructura inicial per als alumnes (un directori per curs)
  Future<void> creaEstructuraAlumnes(Set<String>? nomsCursos) async {
    final baseDir = await _getBaseDirectory();
    final alumnesDir = Directory('${baseDir.path}/$alumnesFolder');

    if (!await alumnesDir.exists()) {
      await alumnesDir.create();
    }

    if (nomsCursos != null) {
      for (final nomCurs in nomsCursos) {
        final cursDir = Directory('${alumnesDir.path}/$nomCurs');
        if (!await cursDir.exists()) {
          await cursDir.create(recursive: true);
        }
      }
    }
  }

  /// Crea la carpeta base de professors si no existeix
  Future<void> creaEstructuraProfessors() async {
    final baseDir = await _getBaseDirectory();
    final professorsDir = Directory('${baseDir.path}/$professorsFolder');

    if (!await professorsDir.exists()) {
      await professorsDir.create(recursive: true);
    }
  }

  /// Obté el path de la carpeta d’un alumne concret
  Future<String> getPathAlumne(String nomCurs, String niaAlumne) async {
    final baseDir = await _getBaseDirectory();
    return '${baseDir.path}/$alumnesFolder/$nomCurs/$niaAlumne.jpg';
  }

  /// Obté el path de la foto d’un professor concret
  Future<String> getPathProfessor(String nomProfessor) async {
    final baseDir = await _getBaseDirectory();
    return '${baseDir.path}/$professorsFolder/$nomProfessor.jpg';
  }

  Future<String> getDirAlumne(String nomCurs, String nomAlumne) async {
    final baseDir = await _getBaseDirectory();
    return '${baseDir.path}/$alumnesFolder/$nomCurs';
  }

  /// Obté el path de la foto d’un professor concret
  Future<String> getDirProfessor(String nomProfessor) async {
    final baseDir = await _getBaseDirectory();
    return '${baseDir.path}/$professorsFolder';
  }

  Future<void> eliminaCarpetesAlumnes(Set<String> nomsCursos) async {
    final baseDir = await _getBaseDirectory();
    final alumnesDir = Directory('${baseDir.path}/$alumnesFolder');

    for (final nomCurs in nomsCursos) {
      final cursDir = Directory('${alumnesDir.path}/$nomCurs');
      if (await cursDir.exists()) {
        await cursDir.delete(recursive: true);
      }
    }
  }

  Future<void> creaCarpetaGrup(String nomCurs) async {
    final baseDir = await _getBaseDirectory();
    final grupDir = Directory('${baseDir.path}/$alumnesFolder/$nomCurs');

    if (!await grupDir.exists()) {
      await grupDir.create(recursive: true);
    }
  }

  Future<void> renombraCarpetaCurs(String nomActual, String nouNom) async {
    final baseDir = await _getBaseDirectory();

    final origen =
        Directory('${baseDir.path}/$baseFolderName/$alumnesFolder/$nomActual');
    final desti =
        Directory('${baseDir.path}/$baseFolderName/$alumnesFolder/$nouNom');

    if (await desti.exists()) {
      throw Exception("Ja existeix una carpeta amb el nom '$nouNom'.");
    }

    if (!await origen.exists()) {
      throw Exception("La carpeta d'origen no existeix.");
    }

    await origen.rename(desti.path);
  }

  /// Elimina totes les fotos (fitxers `.jpg`) dins d'una carpeta de curs i borrar també la carpeta
  Future<void> eliminarFotosCarpetaCurs(String nomCurs) async {
    final baseDir = await _getBaseDirectory();
    final carpetaCurs = Directory('${baseDir.path}/$alumnesFolder/$nomCurs');

    if (await carpetaCurs.exists()) {
      final arxius = carpetaCurs.listSync();

      for (final arxiu in arxius) {
        if (arxiu is File && arxiu.path.endsWith('.jpg')) {
          await arxiu.delete();
        }
      }

      if (carpetaCurs.listSync().isEmpty) {
        await carpetaCurs.delete();
      }
    }
  }

  Future<void> mouFotoAlumne(
      String nomCursVell, String nomCursNou, String niaAlumne) async {
    final baseDir = await _getBaseDirectory();

    final origen =
        File('${baseDir.path}/$alumnesFolder/$nomCursVell/$niaAlumne.jpg');
    final destiDir = Directory('${baseDir.path}/$alumnesFolder/$nomCursNou');

    if (!await destiDir.exists()) {
      await destiDir.create(recursive: true);
    }

    final desti = File('${destiDir.path}/$niaAlumne.jpg');

    if (await origen.exists()) {
      await origen.rename(desti.path);
    }
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
