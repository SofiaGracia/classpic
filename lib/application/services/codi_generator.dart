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
}
