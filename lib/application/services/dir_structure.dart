import 'package:xml_fotos/application/services/saf_methods.dart';

class DirStrucService {
  static Future<void> creaEstructuraInicial(String uri) async {

    await creaEstructuraProfessors();
    await creaEstructuraAlumnes(null);
  }

  /// Crea la carpeta base de professors si no existeix
  static Future<void> creaEstructuraProfessors() async {
    await PlatformChannel.creaEstructuraProf();
  }

  /// Crea l’estructura inicial per als alumnes (un directori per curs)
  static Future<void> creaEstructuraAlumnes(Set<String>? nomsCursos) async {
    if(nomsCursos != null){
      final llistaCursos = nomsCursos.toList();
      await PlatformChannel.creaEstructuraAlu(llistaCursos);
    }else{
      await PlatformChannel.creaEstructuraAlu(null);
    }
  }
}