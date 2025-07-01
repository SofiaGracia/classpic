import 'package:xml_fotos/application/services/saf_methods.dart';

class DirStrucService {
  static Future<void> creaEstructuraInicial(String uri) async {

    await creaEstructuraProfessors(uri);
    await creaEstructuraAlumnes(uri, null);
  }

  /// Crea la carpeta base de professors si no existeix
  static Future<void> creaEstructuraProfessors(String uri) async {
    await PlatformChannel.creaEstructuraProf(uri);
  }

  /// Crea l’estructura inicial per als alumnes (un directori per curs)
  static Future<void> creaEstructuraAlumnes(String uri, Set<String>? nomsCursos) async {
    if(nomsCursos != null){
      final llistaCursos = nomsCursos.toList();
      await PlatformChannel.creaEstructuraAlu(uri, llistaCursos);
    }else{
      await PlatformChannel.creaEstructuraAlu(uri, null);
    }
  }
}