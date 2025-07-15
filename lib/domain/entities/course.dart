import 'package:floor/floor.dart';

@Entity(
  tableName: 'course',
  indices: [Index(value: ['name'], unique: true)],
)
class Course {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final String name;

  Course({this.id, required this.name});

  Course copyWith({
    int? id,
    String? name,
  }) {
    return Course(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }
}
