import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import '../models/sessio.dart';
import '../utils/errorhandler.dart';
import '../utils/exceptions.dart';

typedef JsonReader = Future<Map<String, dynamic>> Function(String path);
typedef JsonWriter = Future<void> Function(
    String path, Map<String, dynamic> data);

class SessioRepository {
  final Future<Directory?> Function() getStorageDir;
  final JsonReader readJson;
  final JsonWriter _writeJson;

  String? _basePath;

  SessioRepository(
    this.getStorageDir,
    this.readJson,
    this._writeJson,
  );

  // Constructor per a producció
  factory SessioRepository.defaultRepo() {
    return SessioRepository(
      getExternalStorageDirectory,
      (path) async {
        final jsonString = await File(path).readAsString();
        return jsonDecode(jsonString);
      },
      (path, data) async {
        final file = File(path);
        await file.writeAsString(jsonEncode(data));
      },
    );
  }

  Future<String> _getOrInitBasePath() async {
    try {
      if (_basePath != null) return _basePath!;

      final directory = await getStorageDir();
      _basePath = directory?.path ?? "/storage/emulated/0/MyApp";

      return _basePath!;
    } catch (e) {
      final errorMessage = ErrorHandler.mapErrorToMessage(e);
      debugPrint(errorMessage);
      return "/storage/emulated/0/MyApp";  // Valor per defecte
    }
  }

  Future<Sessio?> _readMetadataFile(String path) async {
    try{
      final jsonData = await readJson(path);
      final sessio = Sessio.fromJson(jsonData, path, path);
      return sessio;
    } catch (e){
      final errorMessage = ErrorHandler.mapErrorToMessage(e);
      debugPrint(errorMessage);
    }
    return null;
  }

  //Fer este mètode privat?
  Future<void> writeJsonSafely(String path, Map<String, dynamic> data) async {
    try {
      await _writeJson(path, data);
    }  catch (e){
      final errorMessage = ErrorHandler.mapErrorToMessage(e);
      debugPrint(errorMessage);
    }
  }

  Future<List<Sessio>> loadListSession() async {
    List<Sessio> sessioList = [];
    try {
      final basePath = await _getOrInitBasePath();
      final baseDir = Directory(basePath);

      if (!await baseDir.exists()) {
        await baseDir.create(recursive: true);
      } else {
        try {
          final entities = baseDir.listSync();
          for (var entity in entities) {
            if (entity is Directory) {
              final metadataPath = '${entity.path}/metadata.json';

              if (await File(metadataPath).exists()) {
                final sessio = await _readMetadataFile(metadataPath);
                if (sessio != null) { // Comprova si la sessió és vàlida
                  sessioList.add(sessio); // Afegeix a la llista
                }
              }
            }
          }
        } catch (e) {
          throw Exception('Error al llistar directoris: $e');
        }
      }
    } catch (e){
      throw Exception('Error al carregar la llista de sessions: $e');
      //final errorMessage = ErrorHandler.mapErrorToMessage(e);
      //debugPrint(errorMessage);
    }

    return sessioList;
  }

  Future<Sessio> crearSessio() async {
    try {
      final basePath = await _getOrInitBasePath();

      final dataString = DateFormat('yyyy-MM-dd_HH-mm-ss').format(DateTime.now());

      final metadades = {
        'data': dataString,
        'nom': null,
      };

      final sessioDir = Directory('$basePath/$dataString');

      // Intentar crear el directori
      if (!await sessioDir.exists()) {
        await sessioDir.create(recursive: true);
      }

      final metadataPath = '${sessioDir.path}/metadata.json';

      // Crear una instància de Sessio a partir del dataString
      final sessio = Sessio.fromDataString(dataString,
          pathJson: metadataPath, dirPath: sessioDir.path);

      // Intentar escriure les metadades al fitxer JSON
      await writeJsonSafely(metadataPath, metadades);

      return sessio;

    } catch (e){
      throw Exception('Error al crear una nova sessio: $e');
      //final errorMessage = ErrorHandler.mapErrorToMessage(e);
      //debugPrint(errorMessage);
      //rethrow;
    }
  }

  Future<void> guardarMetadades(Sessio sessio, String nomFitxerXmlTrobat) async {

    try {
      final s = await _readMetadataFile(sessio.pathJson);

      if (s != null) {
        var data = {
          "nom": nomFitxerXmlTrobat,
          "data": s.dataString,
        };
        await writeJsonSafely(s.pathJson, data);
      } else {
        debugPrint('Error al llegir les metadades de la sessió');
      }
    } catch (e) {
      throw Exception('Error al llegir el fitxer de metadata: $e');
      //final errorMessage = ErrorHandler.mapErrorToMessage(e);
      //debugPrint(errorMessage);
    }
  }

  Future<void> borrarSessio(Sessio sessio) async {
    try {
      final sessioDir = Directory(sessio.dirPath);

      if (await sessioDir.exists()) {
        await sessioDir.delete(recursive: true);
        print("Sessió eliminada correctament: ${sessio.dirPath}");
      } else {
        print("No s'ha trobat el directori de la sessió: ${sessio.dirPath}");
      }
    } catch (e){
      throw Exception('Error al eliminar sessio: $e');
      //final errorMessage = ErrorHandler.mapErrorToMessage(e);
      //debugPrint(errorMessage);
    }
  }
}
