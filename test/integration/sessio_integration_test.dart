import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:xml_fotos/models/sessio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:xml_fotos/repository/sessio.dart';
import 'package:xml_fotos/screens/sessio.dart';
import 'package:xml_fotos/screens/widgets/sessio.dart';

import '../unit/screens/sessio_test.dart';

// 1. Crea un mock per al repositori
class MockSessioRepository extends Mock implements SessioRepository {}

void main() {
  
  late MockSessioRepository mockRepo;

  setUp(() {
    mockRepo = MockSessioRepository();
  });

  testWidgets('Prova d\'integració de SessioScreen amb injecció manual del repositori', (tester) async {

    // Dades de prova per a la sessió
    final sessio = Sessio.fromDataString(
      '2025-04-13_12-00-00',
      pathJson: '/fake/json',
      dirPath: '/fake/dir',
    );
    sessio.nomFitxerXml = 'alumnes.xml';

    //S'ha de inicialitzar abans la llista per a que quan afegim la nova sessio
    when(() => mockRepo.loadListSession()).thenAnswer((_) async => []);
    when(() => mockRepo.crearSessio()).thenAnswer((_) async => sessio);
    // Simula l'eliminació d'una sessió
    when(() => mockRepo.borrarSessio(sessio)).thenAnswer((_) async {});


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
    expect(find.text('DATA: ${sessio.dataString}'), findsOneWidget);
    expect(find.text('Fitxer xml: ${sessio.nomFitxerXml}'), findsOneWidget);

    //Borrar sessió
    // Realitza la interacció amb el widget
    await tester.tap(find.byIcon(Icons.delete));
    await tester.pumpAndSettle();

    // Comprova que la sessió ha estat eliminada, potser mitjançant un canvi a la interfície
    verify(() => mockRepo.borrarSessio(sessio)).called(1);

  });

  testWidgets('Comprova el comportament amb errors en la càrrega de dades', (tester) async {
    // Simula un error al repositori
    //when(mockRepo.crearSessio()).thenThrow(Exception('Error al carregar la sessió'));
    when(() => mockRepo.loadListSession()).thenAnswer((_) async => []);
    when(() => mockRepo.crearSessio()).thenThrow(Exception('Error al carregar la sessió'));

    await tester.pumpWidget(
      MaterialApp(
        home: SessioScreen(repository: mockRepo),
      ),
    );

    await tester.pumpAndSettle();

    await tester.tap(find.text('Crear una nova sessió'));
    await tester.pumpAndSettle();

    expect(find.byType(SnackBar), findsOneWidget);

    // Comprova que es mostri un missatge d'error
    expect(find.text('Error al crear la sessió: Exception: Error al carregar la sessió'), findsOneWidget);
  });
}
