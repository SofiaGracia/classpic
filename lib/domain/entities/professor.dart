import 'package:floor/floor.dart';
import 'package:xml_fotos/domain/models/usuari.dart';

@Entity(tableName: 'professors')
class Professor extends Usuari {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  String dni;

  @override
  String get usuId => dni;

  Professor({
    this.id,
    required this.dni,
    required String nom,
    required String c1,
    String? c2,
    String? fotoPath,
    String? fotoPathHash,
  }) : super(nom: nom, c1: c1, c2: c2, fotoPath: fotoPath, fotoPathHash: fotoPathHash);

  Professor copyWith({
    int? id,
    String? dni,
    String? nom,
    String? c1,
    String? c2,
    String? fotoPath,
    String? fotoPathHash,
  }) {
    return Professor(
      id: id ?? this.id,
      dni: dni ?? this.dni,
      nom: nom ?? this.nom,
      c1: c1 ?? this.c1,
      c2: c2 ?? this.c2,
      fotoPath: fotoPath ?? fotoPath,
      fotoPathHash: fotoPathHash ?? this.fotoPathHash,
    );
  }
}
