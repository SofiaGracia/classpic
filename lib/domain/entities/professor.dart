import 'package:floor/floor.dart';
import 'package:xml_fotos/domain/models/usuari.dart';

import '../models/foto_info.dart';

@Entity(tableName: 'professors')
class Professor extends Usuari {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  String dni;

  @override
  String get usuId => dni;

  // Mapeig manual: 2 columnes separades
  @ColumnInfo(name: 'foto_folder')
  final String? fotoFolder;

  @ColumnInfo(name: 'foto_filename')
  final String? fotoFilename;

  /// Getter opcional per reconstruir FotoInfo al vol
  FotoInfo? get fotoInfo =>
      (fotoFolder != null && fotoFilename != null)
          ? FotoInfo(folder: fotoFolder!, filename: fotoFilename!)
          : null;

  Professor({
    this.id,
    required this.dni,
    required String nom,
    required String c1,
    String? c2,
    String? fotoPathHash,
    this.fotoFolder,
    this.fotoFilename,
  }) : super(nom: nom, c1: c1, c2: c2, fotoPathHash: fotoPathHash);

  Professor copyWith({
    int? id,
    String? dni,
    String? nom,
    String? c1,
    String? c2,
    String? fotoPathHash,
    String? fotoFolder,
    String? fotoFilename,
  }) {
    return Professor(
      id: id ?? this.id,
      dni: dni ?? this.dni,
      nom: nom ?? this.nom,
      c1: c1 ?? this.c1,
      c2: c2 ?? this.c2,
      fotoPathHash: fotoPathHash ?? this.fotoPathHash,
      fotoFolder: fotoFolder ?? this.fotoFolder,
      fotoFilename: fotoFilename ?? this.fotoFilename,
    );
  }
}
