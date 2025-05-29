import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:path/path.dart' as p;

import 'package:xml_fotos/application/services/storage_service.dart';
import 'package:xml_fotos/shared/utils/constants.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('StorageService - renombraCarpetaCurs', () {
    late Directory tempDir;
    late StorageService storageService;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('test_storage');
      PathProviderPlatform.instance = _FakePathProvider(tempDir.path);
      storageService = StorageService();
    });

    tearDown(() async {
      await tempDir.delete(recursive: true);
    });

    test('renombra correctament una carpeta de curs', () async {
      final nomActual = '1A';// Nom de la carpeta original (curs actual)
      final nouNom = '2B';// Nou nom que volem assignar al curs

      // Ruta completa a la carpeta original dins del directori temporal
      final origenDir = Directory(
        p.join(tempDir.path, baseFolderName, alumnesFolder, nomActual),//Constants que tenim globalment
      );
      await origenDir.create(recursive: true);// Creem la carpeta original de manera recursiva

      // Creem un fitxer fictici dins la carpeta del curs (simulant una foto d’un alumne)
      final fitxerDeProva = File(p.join(origenDir.path, 'exemple.jpg'));
      await fitxerDeProva.writeAsString('foto');// Escriu un contingut fictici dins el fitxer

      // Cridem la funció que volem testejar: ha de renombrar la carpeta del curs
      await storageService.renombraCarpetaCurs(nomActual, nouNom);

      // Ruta esperada de la nova carpeta (amb el nou nom)
      final destiDir = Directory(
        p.join(tempDir.path, baseFolderName, alumnesFolder, nouNom),
      );
      // Ruta del fitxer que esperem trobar dins la carpeta renombrada
      final fotoDesitjada = File(p.join(destiDir.path, 'exemple.jpg'));

      // Verificacions
      expect(await destiDir.exists(), isTrue);
      expect(await origenDir.exists(), isFalse);
      expect(await fotoDesitjada.exists(), isTrue);
    });

    test('llança error si la carpeta d\'origen no existeix', () async {
      final nomActual = 'inexistent';
      final nouNom = 'nou';

      expect(
            () => storageService.renombraCarpetaCurs(nomActual, nouNom),
        throwsException,
      );
    });

    test('llança error si la carpeta de destí ja existeix', () async {
      final nomActual = '1A';
      final nouNom = '2B';

      final origenDir = Directory(
        p.join(tempDir.path, baseFolderName, alumnesFolder, nomActual),
      );
      await origenDir.create(recursive: true);

      final destiDir = Directory(
        p.join(tempDir.path, baseFolderName, alumnesFolder, nouNom),
      );
      await destiDir.create(recursive: true);

      expect(
            () => storageService.renombraCarpetaCurs(nomActual, nouNom),
        throwsException,
      );
    });
  });
}

class _FakePathProvider extends PathProviderPlatform {
  final String fakePath;
  _FakePathProvider(this.fakePath);

  @override
  Future<String?> getExternalStoragePath() async {
    return fakePath;
  }
}
