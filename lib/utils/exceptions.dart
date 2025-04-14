
class FitxerNoTrobatException implements Exception {
  final String message;
  FitxerNoTrobatException([this.message = "El fitxer no ha estat trobat"]);
}

class DirectoriNoTrobatException implements Exception {
  final String message;
  DirectoriNoTrobatException([this.message = "El directori no existeix"]);
}

class PermisDenegatException implements Exception {
  final String message;
  PermisDenegatException(this.message);

  @override
  String toString() => "PermisDenegatException: $message";
}

class FormatInvalidException implements Exception {
  final String message;
  FormatInvalidException(this.message);

  @override
  String toString() => "FormatInvalidException: $message";
}

class LecturaJsonException implements Exception {
  final String message;
  LecturaJsonException([this.message = "Error llegint el fitxer JSON"]);
}

class OperacioNoPermesaException implements Exception {
  final String message;
  OperacioNoPermesaException(this.message);

  @override
  String toString() => "OperacioNoPermesaException: $message";
}

//Esta excepció segurament no l'anirem a gastar per a res
class ErrorDesconegutException implements Exception {
  final String message;
  ErrorDesconegutException(this.message);

  @override
  String toString() => "ErrorDesconegutException: $message";
}
