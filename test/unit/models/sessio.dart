import 'package:test/test.dart';
import 'package:intl/intl.dart';
import 'package:xml_fotos/models/sessio.dart';

void main() {
  group('Sessio', () {
    test('deberia formatar la data correctament', () {
      final sessio = Sessio(
        data: DateTime(2023, 4, 7, 14, 30),
        pathJson: 'path/to/file.json',
        dirPath: 'path/to/dir',
      );
      final dataString = sessio.dataString;
      expect(dataString, equals('2023-04-07 14:30:00'));
    });

    test('deberia crear una instància de Sessio a partir de JSON', () {
      final json = {
        'data': '2023-04-07 14:30:00',
        'nom': 'fitxer.xml',
      };
      final pathJson = 'path/to/file.json';
      final dirPath = 'path/to/dir';

      final sessio = Sessio.fromJson(json, pathJson, dirPath);

      expect(sessio.data, DateTime(2023, 4, 7, 14, 30));
      expect(sessio.nomFitxerXml, equals('fitxer.xml'));
      expect(sessio.pathJson, equals(pathJson));
      expect(sessio.dirPath, equals(dirPath));
    });
  });
}
