import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class GestorCarpetes {
  static final Map<String, String> _carpetes = {};

  static String? obtenirPathCarpeta(String clau){
    String? carpetaPath = _carpetes['$clau'];
    if(carpetaPath !=  null){
      return carpetaPath;
    }
    return null;
  }

  //Açò hi ha que canviar-ho pq ara tenim sessions
  static Future<void> inicialitzarCarpetes(List<String> cursos) async {

    final directory = await getExternalStorageDirectory();
    final basePath = directory?.path ?? "/storage/emulated/0/MyApp";
    final baseDir = Directory(basePath);

    if (!await baseDir.exists()) {
      await baseDir.create(recursive: true);
    }

    for (String curs in cursos) {
      final carpetaPath = path.join(basePath, curs);

      if (!await Directory(carpetaPath).exists()) {
        await Directory(carpetaPath).create(recursive: true);
      }

      _carpetes[curs] = carpetaPath;
    }
  }
}
