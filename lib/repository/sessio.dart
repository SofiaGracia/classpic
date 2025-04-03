
import 'dart:convert';
import 'dart:io';

import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import '../models/sessio.dart';

class SessioRepository {
  List<String> _sessioPathList = [];
  String? _basePath;

  //Anem a tindre una llista de sessions
  List<Sessio> _sessioList = [];

  SessioRepository._();

  static final SessioRepository _instance = SessioRepository._();

  factory SessioRepository() {
    return _instance;
  }

  Future<List<Sessio>> loadListSession() async {

    final directory = await getExternalStorageDirectory();
    _basePath = directory?.path ?? "/storage/emulated/0/MyApp";
    final baseDir = Directory(_basePath!);

    if (!await baseDir.exists()) {
      await baseDir.create(recursive: true);
    } else {
      try {
        List<FileSystemEntity> entities = baseDir.listSync(); // Llista tots els fitxers/directoris

        for (var entity in entities) {
          if (entity is Directory) {
            _sessioPathList.add(entity.path); // Afegim el nom del directori a la llista
            String metadataPath = '${entity.path}/metadata.json';
            File metadataFile = File(metadataPath);

            if (await metadataFile.exists()) {
              try {
                String jsonString = await metadataFile.readAsString();
                Map<String, dynamic> jsonData = jsonDecode(jsonString);

                Sessio sessio = Sessio.fromJson(jsonData, metadataPath, entity.path);
                if (sessio.dataString != null){
                  _sessioList.add(sessio);
                }

              } catch (e) {
                print('Error al llegir el fitxer JSON a ${entity.path}: $e');
              }
            }
          }
        }

      } catch (e) {
        print('Error al llistar directoris: $e');
      }
    }

    return _sessioList; // Ha d'estar fora del try-catch-finally
  }

  Future<Sessio> crearSessio() async {

    DateTime dataSessio = DateTime.now();
    final dataString = DateFormat('yyyy-MM-dd_HH-mm-ss').format(dataSessio);
    final sessioDir = Directory('$_basePath/$dataString');

    if (!await sessioDir.exists()) {
      await sessioDir.create(recursive: true);
    }

    final metadataFile = File('${sessioDir.path}/metadata.json');

    Sessio sessio = Sessio(
      data: dataSessio,
      pathJson: metadataFile.path,
      dirPath: sessioDir.path
    );

    final metadata = {
      'nom': sessio.nomFitxerXml,
      'data': sessio.dataString,
    };

    await metadataFile.writeAsString(jsonEncode(metadata));

    return sessio;
  }

  Future<void> guardarMetadades(Sessio sessio) async {
    final jsonData = {
      'nom': sessio.nomFitxerXml,
      'data': sessio.dataString,
    };

    final file = File(sessio.pathJson);
    await file.writeAsString(jsonEncode(jsonData));
  }

  Future<void> borrarSessio(Sessio sessio) async {
    try {
      final sessioDir = Directory(sessio.dirPath);

      if (await sessioDir.exists()) {
        await sessioDir.delete(recursive: true);
        _sessioList.remove(sessio);
        _sessioPathList.remove(sessio.dirPath);
        print("Sessió eliminada correctament: ${sessio.dirPath}");
      } else {
        print("No s'ha trobat el directori de la sessió: ${sessio.dirPath}");
      }
    } catch (e) {
      print("Error en eliminar la sessió: $e");
    }
  }
}