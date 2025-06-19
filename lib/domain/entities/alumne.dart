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

  String nia;

  @override
  String get usuId => nia;

  late String? grup;

  late int? cursId;

  Alumne({
    this.id,
    required this.nia,
    required String nom,
    required String c1,
    String? c2,
    this.grup,
    String? fotoPathHash,
    this.cursId,
    required String fotoFolder,
    String? fotoFilename
  }) : super(nom: nom, c1: c1, c2: c2, fotoPathHash: fotoPathHash, fotoFolder: fotoFolder, fotoFilename: fotoFilename);

  Alumne copyWith({
    int? id,
    String? nia,
    String? nom,
    String? c1,
    String? c2,
    String? grup,
    String? fotoPathHash,
    int? cursId,
    String? fotoFolder,
    String? fotoFilename,
  }) {
    return Alumne(
      id: id ?? this.id,
      nia: nia ?? this.nia,
      nom: nom ?? this.nom,
      c1: c1 ?? this.c1,
      c2: c2 ?? this.c2,
      grup: grup ?? this.grup,
      fotoPathHash: fotoPathHash ?? this.fotoPathHash,
      cursId: cursId ?? this.cursId,
      fotoFolder: fotoFolder ?? this.fotoFolder,
      fotoFilename: fotoFilename ?? this.fotoFilename,
    );
  }
}
