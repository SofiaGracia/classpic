import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:xml_fotos/models/sessio.dart';
import 'package:xml_fotos/providers/info_xml.dart';
import 'package:xml_fotos/repository/interfaces/icursos.dart';
import 'package:xml_fotos/screens/cicles.dart';
import 'package:xml_fotos/screens/cicles_vell.dart';
import 'package:xml_fotos/screens/import.dart';
import 'package:xml_fotos/screens/widgets/sessio.dart';

import '../../fakes/fake_repository_cursos.dart';

void main() {
  testWidgets('Mostra dades de la sessió i crida onSessioDeleted quan es prem la paperera', (tester) async {
    // Sessió de prova
    final sessio = Sessio.fromDataString(
      '2025-04-13_12-00-00',
      pathJson: '/fake/json',
      dirPath: '/fake/dir',
    );

    bool deleteCridat = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SessioWidget(
            sessio: sessio,
            onSessioDeleted: (_) {
              deleteCridat = true;
            },
          ),
        ),
      ),
    );

    // Comprovar que es mostren les dades correctament
    expect(find.text('DATA: ${sessio.dataString}'), findsOneWidget);
    expect(find.text('Fitxer xml: BUIT'), findsOneWidget);

    // Prem el botó de la paperera
    await tester.tap(find.byIcon(Icons.delete));
    await tester.pump();

    // Verifica que es crida la funció de delete
    expect(deleteCridat, isTrue);
  });

  testWidgets('Navega a ImportScreen si no hi ha XML', (tester) async {
    final sessioSenseXml = Sessio.fromDataString(
      '2025-04-13_13-00-00',
      pathJson: '/fake/dir',
      dirPath: '/fake/dir',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Material( // opcional si ja tens un Scaffold dins el widget
          child: SessioWidget(
            sessio: sessioSenseXml,
            onSessioDeleted: (_) {},
          ),
        ),
      ),
    );

    await tester.tap(find.byType(SessioWidget));
    await tester.pumpAndSettle();

    expect(find.byType(ImportScreen), findsOneWidget);
  });

  testWidgets('Mostra cicles de prova', (tester) async {
    await tester.pumpWidget(
      Provider<IRepositoryCursos>.value(
        value: FakeRepositoryCursos(),
        child: const MaterialApp(home: CiclesScreen()),
      ),
    );

    await tester.pumpAndSettle(); // Espera que acabe el FutureBuilder

    expect(find.text('DAM'), findsOneWidget);
    expect(find.text('DAW'), findsOneWidget);
    expect(find.text('ASIX'), findsOneWidget);
  });

  testWidgets('Navega a CiclesScreen si la sessió té XML', (tester) async {
    final sessioAmbXml = Sessio.fromDataString(
      '2025-04-13_13-00-00',
      pathJson: '/fake/dir',
      dirPath: '/fake/dir',
    );
    sessioAmbXml.nomFitxerXml = 'alumnes.xml';

    await tester.pumpWidget(
      Provider<IRepositoryCursos>.value(
        value: FakeRepositoryCursos(),
        child: MaterialApp(
          home: Material(
            child: SessioWidget(
              sessio: sessioAmbXml,
              onSessioDeleted: (_) {},
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byType(SessioWidget));
    await tester.pumpAndSettle();

    expect(find.byType(CiclesScreen), findsOneWidget);
  });
}
