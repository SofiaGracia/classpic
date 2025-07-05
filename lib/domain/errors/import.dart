abstract class ImportError implements Exception {
  String get message;
}

class DirectoriBaseNoTriat extends ImportError {
  @override
  String get message => 'Has de seleccionar primer un directori per guardar les fotos.';
}

class XmlNoCarregat extends ImportError {
  @override
  String get message => 'No s\'ha pogut carregar el fitxer XML.';
}

class AltreError extends ImportError {
  final String cause;
  AltreError(this.cause);

  @override
  String get message => cause;
}
