import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:xml/xml.dart';
import 'package:xml_fotos/application/services/alumne_import_handler.dart';
import 'package:xml_fotos/application/services/storage_service.dart';
import 'package:xml_fotos/data/datasources/xml/alumne_xml.dart';
import 'package:xml_fotos/domain/entities/alumne.dart';
import 'package:xml_fotos/domain/entities/curs.dart';
import 'package:xml_fotos/presentation/providers/alumne_notifier.dart';

import 'fake_alumnes_notifier.dart';

//Comprovar si es crida a _actualitzaAlumnes()
class MockRepositoryAlumneXml extends Mock implements RepositoryAlumneXml {}

class MockStorageService extends Mock implements StorageService {}

class MockAlumneImportHandler extends Mock implements AlumneImportHandler {}

void main() {
  late MockStorageService mockStorage;
  late MockRepositoryAlumneXml mockRepo;
  late MockAlumneImportHandler mockHandler;

  setUp(() {
    mockStorage = MockStorageService();
    mockRepo = MockRepositoryAlumneXml();
    mockHandler = MockAlumneImportHandler();
  });

  test('En processa() es crida a actualitzaAlumnes() correctament', () async {
    final cursosMock = [
      Curs(id: 1, nom: 'A'),
      Curs(id: 2, nom: 'B'),
    ];
    final cursosXml = cursosMock.map((c) => c.nom).toSet();
    final alumnesXml = [
      Alumne(nia: '123', nom: 'Roser', c1: 'Gracia', grup: 'A', cursId: 1)
    ];

    final alumnesDB = [
      Alumne(nia: '123', nom: 'Sofia', c1: 'Gracia', grup: 'A', cursId: 1)
    ];

    final container = ProviderContainer(
      overrides: [
        alumnesNotifierProvider
            .overrideWith(() => FakeAlumnesNotifier(alumnesXml)),
      ],
    );

    final handler = AlumneImportHandler(container, mockStorage);

    // Crear un document XML mínim vàlid
    final xmlString = '<root></root>';
    final doc = XmlDocument.parse(xmlString);

    Map<String, dynamic> mapa = {'alumnes': alumnesXml, 'cursos': cursosXml};

    when(() => mockRepo.parseAlumnesFromXml(doc)).thenAnswer((_) => mapa);

    final result = await handler.processa(doc);
    //Comprova resulstats
    verify(() => mockHandler.actualitzaAlumnes(
        mockRepo, alumnesXml, alumnesDB, cursosXml)).called(1);
  });
}
