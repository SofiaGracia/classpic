import 'package:floor/floor.dart';
import 'package:xml_fotos/models/usuari.dart';

@Entity(tableName: 'professors')
class Professor extends Usuari {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  String dni;

  Professor({
    this.id,
    required this.dni,
    required String nom,
    required String c1,
    String? c2,
    String? fotoPath,
  }) : super(nom: nom, c1: c1, c2: c2, fotoPath: fotoPath);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Professor && dni == other.dni;

  @override
  int get hashCode => dni.hashCode;

  Professor copyWith({
    int? id,
    String? dni,
    String? nom,
    String? c1,
    String? c2,
    String? fotoPath,
  }) {
    return Professor(
      id: id ?? this.id,
      dni: dni ?? this.dni,
      nom: nom ?? this.nom,
      c1: c1 ?? this.c1,
      c2: c2 ?? this.c2,
      fotoPath: fotoPath ?? fotoPath
    );
  }
}
