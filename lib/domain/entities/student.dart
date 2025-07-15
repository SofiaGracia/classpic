import 'package:floor/floor.dart';
import 'package:xml_fotos/domain/models/user.dart';

import 'course.dart';

@Entity(
  tableName: 'student',
  foreignKeys: [
    ForeignKey(
      childColumns: ['coursId'],
      parentColumns: ['id'],
      entity: Course,
      onDelete: ForeignKeyAction.setNull,
    )
  ],
)
class Student extends User {
  static const String enrollmentStatus = 'M';

  @PrimaryKey(autoGenerate: true)
  final int? id;

  String nia;

  @override
  String get uId => nia;

  late String? group;

  late int? courseId;

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

  Student({
    this.id,
    required this.nia,
    required this.name,
    required this.s1,
    required this.hasFoto,
    this.s2,
    this.photoPathHash,
    this.courseId,
    this.group
  });

  Student copyWith({
    int? id,
    String? nia,
    String? name,
    String? s1,
    String? s2,
    String? grup,
    String? photoPathHash,
    int? cursId,
    bool? hasFoto
  }) {
    return Student(
      id: id ?? this.id,
      nia: nia ?? this.nia,
      name: name ?? this.name,
      s1: s1 ?? this.s1,
      s2: s2 ?? this.s2,
      group: grup ?? this.group,
      photoPathHash: photoPathHash ?? this.photoPathHash,
      courseId: cursId ?? this.courseId,
      hasFoto: hasFoto ?? this.hasFoto
    );
  }
}
