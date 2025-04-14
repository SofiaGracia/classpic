import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:mocktail/mocktail.dart';
import 'package:xml_fotos/models/sessio.dart';
import 'package:xml_fotos/repository/sessio.dart';
import 'package:xml_fotos/screens/sessio.dart';
import 'package:xml_fotos/screens/sessio.dart';
import 'package:xml_fotos/screens/widgets/sessio.dart';

class MockSessioRepository extends Mock implements SessioRepository {}

void main() {
  late MockSessioRepository mockRepo;

  setUp(() {
    mockRepo = MockSessioRepository();
  });

  testWidgets('Mostra missatge quan no hi ha cap sessió', (tester) async {
    // Preparar el mock
    when(() => mockRepo.loadListSession()).thenAnswer((_) async => []);

    await tester.pumpWidget(
      MaterialApp(
        home: SessioScreen(repository: mockRepo),
      ),
    );

    // Esperar que es carregui el widget i cridi el repositori
    await tester.pumpAndSettle();

    expect(find.text("No hi ha cap sessió disponible"), findsOneWidget);
  });

  testWidgets('Afegeix una sessió quan es prem el botó', (tester) async {

    final dataNow = DateTime.now();
    String data = DateFormat('yyyy-MM-dd_HH-mm-ss').format(dataNow);
    final dirFals = Directory('/tmp/fakeStorageDir');
    dirFals.createSync(recursive: true);

    final sessioFalsa = Sessio.fromDataString(data, pathJson: dirFals.path, dirPath: dirFals.path);

    //final sessioFalsa = Sessio(nom: 'Sessió Test', data: DateTime.now());

    when(() => mockRepo.loadListSession()).thenAnswer((_) async => []);
    when(() => mockRepo.crearSessio()).thenAnswer((_) async => sessioFalsa);

    await tester.pumpWidget(
      MaterialApp(
        home: SessioScreen(repository: mockRepo),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text("No hi ha cap sessió disponible"), findsOneWidget);

    // Prem el botó
    await tester.tap(find.text('Crear una nova sessió'));
    await tester.pumpAndSettle();

    // Ara hauria d’haver desaparegut el missatge i aparèixer la nova sessió
    expect(find.text("No hi ha cap sessió disponible"), findsNothing);
    expect(find.byType(SessioWidget), findsOneWidget);
    expect(find.text('DATA: ${sessioFalsa.dataString}'), findsOneWidget);
    expect(find.text('Fitxer xml: BUIT'), findsOneWidget);

    //Borrem el directori fals
    dirFals.deleteSync(recursive: true);
  });
}
