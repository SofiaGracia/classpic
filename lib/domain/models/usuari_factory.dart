import 'package:xml_fotos/domain/models/usuari.dart';

import '../entities/alumne.dart';
import '../entities/professor.dart';

class UsuariFactory {
  static Usuari create({
    required bool isAlumne,
    required String usuId,
    required String nom,
    required String c1,
    required String? c2,
    required bool hasFoto,
    String? fotoPathHash,
  }) {
    if (isAlumne) {
      return Alumne(
          nia: usuId,
          nom: nom,
          c1: c1,
          c2: c2,
          hasFoto: hasFoto,
          fotoPathHash: fotoPathHash);
    } else {
      return Professor(
          dni: usuId,
          nom: nom,
          c1: c1,
          c2: c2,
          hasFoto: hasFoto,
          fotoPathHash: fotoPathHash);
    }
  }
}
