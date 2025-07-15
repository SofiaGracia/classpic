import 'package:floor/floor.dart';
import 'package:xml_fotos/domain/models/user.dart';

@Entity(tableName: 'teacher')
class Teacher extends User {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  String dni;

  @override
  String get uId => dni;

  @override
  bool hasFoto;

  @override
  String name;

  @override
  String? photoPathHash;

  @override
  String s1;

  @override
  String? s2;

  Teacher({
    this.id,
    required this.dni,
    required this.name,
    required this.s1,
    required this.hasFoto,
    this.s2,
    this.photoPathHash,
  });

  Teacher copyWith({
    int? id,
    String? dni,
    String? name,
    String? s1,
    String? s2,
    String? photoPathHash,
    bool? hasFoto
  }) {
    return Teacher(
      id: id ?? this.id,
      dni: dni ?? this.dni,
      name: name ?? this.name,
      s1: s1 ?? this.s1,
      s2: s2 ?? this.s2,
      photoPathHash: photoPathHash ?? this.photoPathHash,
      hasFoto: hasFoto ?? this.hasFoto
    );
  }
}
