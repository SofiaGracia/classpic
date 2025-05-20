import 'package:floor/floor.dart';
import 'package:xml_fotos/domain/models/usuari.dart';

import 'curs.dart';


@Entity(
  tableName: 'alumnes',
  foreignKeys: [
    ForeignKey(
      childColumns: ['cursId'],
      parentColumns: ['id'],
      entity: Curs,
      onDelete: ForeignKeyAction.setNull,
    )
  ],
)
class Alumne extends Usuari {

  static const String estatMatriculat = 'M';

  @PrimaryKey(autoGenerate: true)
  final int? id;

  //@ColumnInfo(name: 'nia', unique: true)
  String nia;

  @override
  String get usuId => nia;

  //Ara en principi curs podria ser required i no null
  final String? grup;

  late int? cursId;

  Alumne({
    this.id,
    required this.nia,
    required String nom,
    required String c1,
    String? c2,
    this.grup,
    String? fotoPath,
    String? fotoPathHash,
    this.cursId,
  }) : super(nom: nom, c1: c1, c2: c2, fotoPath: fotoPath, fotoPathHash: fotoPathHash);

  Alumne copyWith({
    int? id,
    String? nia,
    String? nom,
    String? c1,
    String? c2,
    String? grup,
    String? fotoPath,
    String? fotoPathHash,
    int? cursId,
  }) {
    return Alumne(
      id: id ?? this.id,
      nia: nia ?? this.nia,
      nom: nom ?? this.nom,
      c1: c1 ?? this.c1,
      c2: c2 ?? this.c2,
      grup: grup ?? this.grup,
      fotoPath: fotoPath ?? this.fotoPath,
      fotoPathHash: fotoPathHash ?? this.fotoPathHash,
      cursId: cursId ?? this.cursId,
    );
  }
}
