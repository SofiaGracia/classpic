import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xml_fotos/shared/utils/guide_oval_painter.dart';

void main() {
  testWidgets('GuideOvalPainter es renderitza correctament', (WidgetTester tester) async {
    final paintKey = Key('guide_oval_painter');

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomPaint(
            key: paintKey,
            painter: GuideOvalPainter(),
            child: SizedBox(width: 200, height: 200),
          ),
        ),
      ),
    );

    // Ara busquem només el CustomPaint que hem etiquetat amb Key
    final customPaintFinder = find.byKey(paintKey);
    expect(customPaintFinder, findsOneWidget);

    // I comprovem que el seu painter és del tipus GuideOvalPainter
    final customPaint = tester.widget<CustomPaint>(customPaintFinder);
    expect(customPaint.painter.runtimeType, GuideOvalPainter);
  });
}
