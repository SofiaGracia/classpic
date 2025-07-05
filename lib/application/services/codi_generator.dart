import '../../shared/utils/constants.dart';

class CodiGenerator {
  static Future<String> generaCodi({
    required bool isAlumne,
    required Future<bool> Function(String) existeixFunc,
  }) async {
    final prefix = isAlumne ? 'AAA' : 'PPP';
    for (int i = 1; i < 9999999; i++) {
      final codi = '$prefix${i.toString().padLeft(7, '0')}';
      if (!await existeixFunc(codi)) return codi;
    }
    throw Exception('No queden codis disponibles');
  }

  static String normalitzaIdentificador(String valor) {
    final trimmed = valor.trim();

    // Si ja fa 10 caràcters o més, no modifiquem res
    if (trimmed.length >= 10) return trimmed;

    // Afegim tants zeros com calgui fins a arribar a 10 caràcters
    return trimmed.padRight(10, '0');
  }

  // Funció per normalitzar l'identificador
  /*static String normalitzaId(String idInput) {
    //Per al nia
    if (idInput.length == numNia) {
      return CodiGenerator.normalitzaIdentificador(idInput);
    }

    //Per al dni
    if (idInput.length == numDni) {
      return CodiGenerator.normalitzaIdentificador(idInput);
    }

    //Per si és l'id generat per defecte
    if (idInput.length == numMax) {
      return idInput;
    }

    throw FormatException('L\'ID ha de tenir entre $numNia i 10 caràcters.');
  }*/
}
