import 'package:xml_fotos/domain/models/user.dart';

import '../entities/alumne.dart';
import '../entities/teacher.dart';

class UserFactory {
  static User create({
    required bool isAlumne,
    required String uId,
    required String name,
    required String s1,
    required String? s2,
    required bool hasFoto,
    String? photoPathHash,
  }) {
    if (isAlumne) {
      return Alumne(
          nia: uId,
          name: name,
          s1: s1,
          s2: s2,
          hasFoto: hasFoto,
          photoPathHash: photoPathHash);
    } else {
      return Teacher(
          dni: uId,
          name: name,
          s1: s1,
          s2: s2,
          hasFoto: hasFoto,
          photoPathHash: photoPathHash);
    }
  }
}
