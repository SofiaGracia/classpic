import 'dart:io';

import '../../shared/utils/constants.dart';


class DirStrucService {
  static Future<void> creaEstructuraInicial(String uri) async {
    await creaEstructuraProfessors(uri);
    await creaEstructuraAlumnes(uri, null);
  }

  /// Crea l’estructura inicial per als alumnes (un directori per curs)
  static Future<void> creaEstructuraAlumnes(String uri, Set<String>? nomsCursos) async {
    final alumnesDir = Directory('$uri/$alumnesFolder');

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
  static Future<void> creaEstructuraProfessors(String uri) async {

    //final profDir = await Saf.

    final professorsDir = Directory('$uri/$professorsFolder');

    if (!await professorsDir.exists()) {
      try{
        await professorsDir.create(recursive: true);
      }catch (e){
        print(e);
      }
    }
  }
}