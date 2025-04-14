import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:mockito/mockito.dart';
import 'package:xml_fotos/models/sessio.dart';
import 'package:xml_fotos/repository/sessio.dart';

class MockJsonReader extends Mock {
  Future<Map<String, dynamic>> readJson(String path);
}

class MockJsonWriter extends Mock {
  Future<void> writeJson(String path, Map<String, dynamic> data);
}

void main() {
  group('SessioRepository', () {
    late MockJsonReader mockJsonReader;
    late MockJsonWriter mockJsonWriter;
    late Directory fakeDir;

    Future<Sessio> crearSessioFalsa() async {
      final dataString =
          DateFormat('yyyy-MM-dd_HH-mm-ss').format(DateTime.now());
      final sessioDir = Directory('$fakeDir/$dataString');
      if (!await sessioDir.exists()) {
        await sessioDir.create(
            recursive: true); // Creem el directori si no existeix
      }

      final metadataPath = '${sessioDir.path}/metadata.json';

      final metadades = {
        'data': dataString,
        'nom': null,
      };

      final file = File(metadataPath);
      await file.writeAsString(jsonEncode(metadades));

      final sessio = Sessio.fromDataString(dataString,
          pathJson: metadataPath, dirPath: sessioDir.path);

      return sessio;
    }

    Future<Map<String, dynamic>> llegirMetadades(String path) async {
      final file = File(path);
      final jsonString = await file.readAsString();
      return jsonDecode(jsonString);
    }

    Future<void> escriureMetadades(
        String path, Map<String, dynamic> data) async {
      final file = File(path);
      await file.writeAsString(jsonEncode(data));
    }

    Future<Sessio> setupSessioFalsaCompleta() async {
      final sessio = await crearSessioFalsa();
      final dir = Directory(sessio.dirPath);
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }
      return sessio;
    }

    setUp(() {
      mockJsonReader = MockJsonReader();
      mockJsonWriter = MockJsonWriter();
      fakeDir = Directory('/tmp/fakeStorageDir');
      fakeDir.createSync(recursive: true);
    });

    tearDown(() async {
      await fakeDir.delete(recursive: true);
    });

    test('crearSessio llença una excepció si falla getStorageDir', () async {
      final repo = SessioRepository(
        () => throw Exception('Error al obtenir el directori'),
        mockJsonReader.readJson,
        mockJsonWriter.writeJson,
      );

      expect(() => repo.crearSessio(), throwsA(isA<Exception>()));
    });

    test('crearSessio ha de crear un directori i un fitxer de metadades vàlid',
        () async {
      final expectedDir = fakeDir;
      late String savedPath; // Guardarem el path que es vol escriure
      late Map<String, dynamic> savedData;

      final repo = SessioRepository(
        () async => expectedDir,
        mockJsonReader.readJson,
        (path, data) async {
          savedPath = path;
          savedData = data;

          // Escriu el fitxer com es fa normalment
          final file = File(path);
          await file.writeAsString(jsonEncode(data));
        },
      );

      final sessio = await repo.crearSessio();

      // Verifica que el directori existeix
      final createdDir = Directory(sessio.dirPath);
      expect(await createdDir.exists(), isTrue);

      // Verifica que el fitxer existeix i té contingut vàlid
      final metadataFile = File(sessio.pathJson);
      expect(await metadataFile.exists(), isTrue);
      final jsonContent = await metadataFile.readAsString();
      final data = jsonDecode(jsonContent);

      // Comprovacions de dades
      expect(data.containsKey("data"), isTrue);
      expect(data["data"],
          matches(RegExp(r'\d{4}-\d{2}-\d{2}_\d{2}-\d{2}-\d{2}')));
      expect(data.containsKey("nom"), isTrue);
      expect(data["nom"], isNull);

      // Opcional: també podem verificar que els valors són iguals als que vam interceptar
      expect(savedPath, equals(sessio.pathJson));
      expect(savedData, equals(data));
    });

    test('loadListSession carrega sessions des de fitxers JSON', () async {
      final repo = SessioRepository(
        () async => fakeDir,
        (path) async => {
          "nom": "test.xml",
          "data": "2025-04-07_12-00-00",
        },
        (path, data) async {},
      );

      final fakeSubdir = Directory('${fakeDir.path}/subdir');
      fakeSubdir.createSync(recursive: true);

      final metadataFile = File('${fakeSubdir.path}/metadata.json');
      await metadataFile
          .writeAsString('{"nom": "test.xml", "data": "2025-04-07_12-00-00"}');

      final llista = await repo.loadListSession();

      expect(llista.length, 1);
      expect(llista[0].nomFitxerXml, "test.xml");
      expect(llista[0].dataString, "2025-04-07_12-00-00");
    });

    test('loadListSession retorna llista buida si no hi ha sessions', () async {
      final repo = SessioRepository(
        () async => fakeDir,
        (path) async => {},
        (path, data) async {},
      );

      // Simulem una resposta buida per als fitxers JSON
      final llista = await repo.loadListSession();

      // Comprovem que la llista estigui buida
      expect(llista, isEmpty);
    });

    test('guardarMetadades guarda la dada nom al fitxer de sessió existent',
        () async {
      final sessio = await setupSessioFalsaCompleta();

      final repo = SessioRepository(
        () async => Directory(sessio.dirPath),
        (path) async => await llegirMetadades(path),
        (path, data) async {
          final nomAntic = (await llegirMetadades(path))['nom'];
          await escriureMetadades(path, data);
          final nomNou = data['nom'];
          expect(nomAntic != nomNou, isTrue);
        },
      );

      repo.guardarMetadades(sessio, 'nou_nom.xml');

      if (await Directory(sessio.dirPath).exists()) {
        await Directory(sessio.dirPath).delete(recursive: true);
      }
    });

    test('borrarSessio borra la Sessio pasada per argument', () async {
      final sessio = await setupSessioFalsaCompleta();
      final dir = Directory(sessio.dirPath);

      final repo = SessioRepository(
            () async => dir,
            (path) async => await llegirMetadades(path),
            (path, data) async {},
      );

      await repo.borrarSessio(sessio);
      expect(await dir.exists(), isFalse);
    });
  });
}
