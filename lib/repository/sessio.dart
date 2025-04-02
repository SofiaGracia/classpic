
import 'dart:convert';
import 'dart:io';

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

                Sessio sessio = Sessio.fromJson(jsonData);
                if (sessio.data != null){
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

  //Ací també podriem tindre una funció per a crear una sessió
  Future<Sessio> crearSessio() async {

    Sessio sessio = Sessio();

    final sessioDir = Directory('$_basePath/${sessio.dataString}');

    if (!await sessioDir.exists()) {
      await sessioDir.create(recursive: true);
    }

    final metadataFile = File('${sessioDir.path}/metadata.json');
    final metadata = {
      'nom': sessio.nomFitxerXml,
      'data': sessio.dataString,
    };

    await metadataFile.writeAsString(jsonEncode(metadata));

    return sessio;
  }
}