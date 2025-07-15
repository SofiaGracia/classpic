import 'package:floor/floor.dart';
import 'package:xml_fotos/domain/models/user.dart';

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
class Alumne extends User {
  static const String estatMatriculat = 'M';

  @PrimaryKey(autoGenerate: true)
  final int? id;

  String nia;

  @override
  String get uId => nia;

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
    required bool hasFoto
  }) : super(name: nom, s1: c1, s2: c2, photoPathHash: fotoPathHash, hasFoto: hasFoto);

  Alumne copyWith({
    int? id,
    String? nia,
    String? nom,
    String? c1,
    String? c2,
    String? grup,
    String? fotoPathHash,
    int? cursId,
    bool? hasFoto
  }) {
    return Alumne(
      id: id ?? this.id,
      nia: nia ?? this.nia,
      nom: nom ?? this.name,
      c1: c1 ?? this.s1,
      c2: c2 ?? this.s2,
      grup: grup ?? this.grup,
      fotoPathHash: fotoPathHash ?? this.photoPathHash,
      cursId: cursId ?? this.cursId,
      hasFoto: hasFoto ?? this.hasFoto
    );
  }
}
