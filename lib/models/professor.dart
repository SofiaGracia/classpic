import 'package:floor/floor.dart';
import 'package:xml_fotos/models/usuari.dart';

@Entity(tableName: 'professors')
class Professor extends Usuari {

  @PrimaryKey(autoGenerate: true)
  final int? id;

  final String dni;

  Professor({
    this.id,
    required this.dni,
    required String nom,
    required String c1,
    String? c2,
    String? fotoPath,
  }) : super(nom: nom, c1: c1, c2: c2, fotoPath: fotoPath);
}
