import 'package:intl/intl.dart';

class Sessio {
  DateTime data;
  String? nomFitxerXml;

  Sessio({DateTime? data, this.nomFitxerXml}) : data = data ?? DateTime.now();

  // Mètode per obtenir la data com a string
  String get dataString => DateFormat('yyyy-MM-dd HH:mm:ss').format(data);

  // Constructor de fàbrica per crear una instància de Sessio a partir d'un JSON
  factory Sessio.fromJson(Map<String, dynamic> json) {
    return Sessio(
      data: json['data'] != null
          ? DateFormat('yyyy-MM-dd HH:mm:ss').parse(json['data'])
          : null,
      nomFitxerXml: json['nom'],
    );
  }
}
