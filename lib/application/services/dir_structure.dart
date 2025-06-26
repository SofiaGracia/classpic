import 'dart:io';

import 'package:xml_fotos/application/services/saf_methods.dart';

import '../../shared/utils/constants.dart';

class DirStrucService {
  static Future<void> creaEstructuraInicial(String uri) async {

    final newDirUri = await PlatformChannel.createSubdirectory(uri, baseFolderName);

    await creaEstructuraProfessors(newDirUri!);
    await creaEstructuraAlumnes(newDirUri, null);
  }

  /// Crea la carpeta base de professors si no existeix
  static Future<void> creaEstructuraProfessors(String uri) async {
    await PlatformChannel.createSubdirectory(uri, professorsFolder);
  }

  /// Crea l’estructura inicial per als alumnes (un directori per curs)
  static Future<void> creaEstructuraAlumnes(String uri, Set<String>? nomsCursos) async {

    if(nomsCursos != null){
      for (final nomCurs in nomsCursos) {
        await PlatformChannel.createSubdirectory(uri, '$baseFolderName/$alumnesFolder/$nomCurs');
      }
    }else{
      await PlatformChannel.createSubdirectory(uri, alumnesFolder);
    }
  }
}