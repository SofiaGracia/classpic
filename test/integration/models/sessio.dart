import 'package:test/test.dart';
import 'dart:convert';
import 'dart:io';
import 'package:xml_fotos/models/sessio.dart';

void main() {
  group('Sessio - Tests d\'integració', () {
    test('deuria crear una sessió a partir d\'un fitxer JSON existent', () async {
      // Creem un fitxer JSON simulat
      final file = File('test/integration/sessio_test.json');
      await file.writeAsString(jsonEncode({
        'data': '2023-04-07 14:30:00',
        'nom': 'fitxer.xml',
      }));

      // Llegim el fitxer JSON
      final json = jsonDecode(await file.readAsString());

      // Creem la sessió a partir del JSON
      final sessio = Sessio.fromJson(json, 'test/integration/sessio_test.json', '/path/to/dir');

      // Verifiquem que la sessió es crea correctament
      expect(sessio.data, DateTime(2023, 4, 7, 14, 30));
      expect(sessio.nomFitxerXml, equals('fitxer.xml'));
      expect(sessio.pathJson, equals('test/integration/sessio_test.json'));
      expect(sessio.dirPath, equals('/path/to/dir'));

      // Elimina el fitxer de test
      await file.delete();
    });

    test('deuria manejar un fitxer JSON no vàlid', () async {
      // Creem un fitxer JSON mal format
      final file = File('test/integration/sessio_test_invalid.json');
      await file.writeAsString('{"data": "2023-04-07 14:30:00", "nom": "fitxer.xml"'); // JSON trencat

      // Intentem llegir el fitxer i crear la sessió
      try {
        final json = jsonDecode(await file.readAsString());
        final sessio = Sessio.fromJson(json, 'test/integration/sessio_test_invalid.json', '/path/to/dir');
        fail('No s\'hauria d\'haver creat la sessió amb un JSON mal format');
      } catch (e) {
        // Comprovem que es llenci una excepció
        expect(e, isA<FormatException>());
      }

      // Elimina el fitxer de test
      await file.delete();
    });
  });
}
