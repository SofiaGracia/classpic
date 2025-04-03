import 'package:intl/intl.dart';

class Sessio {
  DateTime data;
  String? nomFitxerXml;
  String pathJson;
  String dirPath;

  Sessio({DateTime? data, this.nomFitxerXml, required this.pathJson, required this.dirPath}) : data = data ?? DateTime.now();

  // Mètode per obtenir la data com a string
  String get dataString => DateFormat('yyyy-MM-dd HH:mm:ss').format(data);

  // Constructor de fàbrica per crear una instància de Sessio a partir d'un JSON
  factory Sessio.fromJson(Map<String, dynamic> json, String pathJson, String dirPath) {
    return Sessio(
      data: json['data'] != null
          ? DateFormat('yyyy-MM-dd HH:mm:ss').parse(json['data'])
          : null,
      nomFitxerXml: json['nom'],
      pathJson: pathJson,
      dirPath: dirPath
    );
  }
}
