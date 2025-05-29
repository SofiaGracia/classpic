import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:xml/xml.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xml_fotos/application/services/alumne_import_handler.dart';
import 'package:xml_fotos/application/services/storage_service.dart';
import 'package:xml_fotos/data/datasources/xml/alumne_xml.dart';
import 'package:xml_fotos/domain/entities/alumne.dart';
import 'package:xml_fotos/domain/entities/curs.dart';
import 'package:xml_fotos/presentation/providers/cursos_notifier.dart';

import 'fake_cursos_notifier.dart';

class MockStorageService extends Mock implements StorageService {}

class MockRepositoryAlumneXml extends Mock implements RepositoryAlumneXml {}

void main() {

  late MockStorageService mockStorage;
  late MockRepositoryAlumneXml mockRepo;

  setUp(() {
    mockStorage = MockStorageService();
    mockRepo = MockRepositoryAlumneXml();
  });

  test('importaPrimeraVegada fa tot correctament', () async {
    final cursosMock = [
      Curs(id: 1, nom: 'A'),
      Curs(id: 2, nom: 'B'),
    ];

    final alumnesXml = [
      Alumne(nia: '123', nom: 'Sofia', c1: 'Gracia', grup: 'A', cursId: 1)
    ];
    final cursosXml = cursosMock.map((c) => c.nom).toSet();

    final container = ProviderContainer(
      overrides: [
        cursosNotifierProvider.overrideWith(() => FakeCursosNotifier(cursosMock)),
      ],
    );

    // Setups de mètodes del storage i del repo
    when(() => mockStorage.creaEstructuraAlumnes(cursosXml)).thenAnswer((_) async {});
    when(() => mockRepo.assignaIdCursAlsAlumnes(alumnesXml, cursosMock))
        .thenAnswer((_) async => alumnesXml);

    // Injecta el container com a ref
    final handler = AlumneImportHandler(container, mockStorage);
    final result =
        await handler._importaPrimeraVegada(mockRepo, alumnesXml, cursosXml);

    // Comprova resultats
    expect(result, equals(alumnesXml));
    verify(() => mockStorage.creaEstructuraAlumnes(cursosXml)).called(1);
  });
}
