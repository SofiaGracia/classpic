import 'package:floor/floor.dart';

@Entity(tableName: 'cursos')
class Curs {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final String nom;

  Curs({this.id, required this.nom});

  Curs copyWith({
    int? id,
    String? nom,
  }) {
    return Curs(
      id: id ?? this.id,
      nom: nom ?? this.nom,
    );
  }
}
