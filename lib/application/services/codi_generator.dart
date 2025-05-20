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
}
