import '../entities/alumne.dart';
import '../entities/teacher.dart';

abstract class User {

  String get uId;
  String get name;
  String get s1;
  String? get s2;

  // Add photoPathHash for logic cache
  String? get photoPathHash;

  // Used to count how many users have photo
  bool get hasFoto;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User &&
        other.uId == uId &&
        other.name == name &&
        other.s1 == s1 &&
        other.s2 == s2 &&
        other.photoPathHash == photoPathHash &&
        other.hasFoto == hasFoto &&
        runtimeType == other.runtimeType;
  }

  @override
  int get hashCode => Object.hash(uId, name, s1, s2, photoPathHash, hasFoto, runtimeType);

  int? get idDB => this is Alumne ? (this as Alumne).id : (this as Teacher).id;
}
