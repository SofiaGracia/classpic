import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:path/path.dart' as p;

import 'package:xml_fotos/application/services/storage_service.dart';
import 'package:xml_fotos/shared/utils/constants.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('StorageService - mouFotoAlumne', () {
    late Directory tempDir;
    late StorageService storageService;

    setUp(() async {
      // Crea un directori temporal per simular l’external storage
      tempDir = await Directory.systemTemp.createTemp('test_storage');

      // Sobreescriu el comportament de getExternalStorageDirectory()
      PathProviderPlatform.instance = _FakePathProvider(tempDir.path);

      storageService = StorageService();
    });

    tearDown(() async {
      await tempDir.delete(recursive: true);
    });

    test('mou la foto d\'un alumne d\'un curs a un altre', () async {
      final nomCursVell = '1A';
      final nomCursNou = '2B';
      final nomAlumne = 'SofiaGracia';

      final origenDir = Directory(
        p.join(tempDir.path, baseFolderName, alumnesFolder, nomCursVell),
      );
      await origenDir.create(recursive: true);

      final fotoOrigen = File(p.join(origenDir.path, '$nomAlumne.jpg'));
      await fotoOrigen.writeAsString('foto de prova');

      // Assegura que la foto existeix al directori original
      expect(await fotoOrigen.exists(), isTrue);

      // Executa la funció
      await storageService.mouFotoAlumne(nomCursVell, nomCursNou, nomAlumne);

      final desti = File(p.join(
        tempDir.path,
        baseFolderName,
        alumnesFolder,
        nomCursNou,
        '$nomAlumne.jpg',
      ));

      // Verifica que la foto ha estat moguda
      expect(await desti.exists(), isTrue);
      expect(await fotoOrigen.exists(), isFalse);
    });
  });
}

// Implementació fake del path provider per retornar el directori temporal
class _FakePathProvider extends PathProviderPlatform {
  final String fakePath;
  _FakePathProvider(this.fakePath);

  @override
  Future<String?> getExternalStoragePath() async {
    return fakePath;
  }
}
