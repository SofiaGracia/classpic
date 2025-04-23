import 'package:floor/floor.dart';
import 'package:xml_fotos/models/usuari.dart';

@Entity(tableName: 'alumnes')
class Alumne extends Usuari {

  static const String estatMatriculat = 'M';

  @PrimaryKey(autoGenerate: true)
  final int? id;

  //@ColumnInfo(name: 'nia', unique: true)
  String nia;

  String? grup;

  Alumne({
    this.id,
    required this.nia,
    required String nom,
    required String c1,
    String? c2,
    this.grup,
    String? fotoPath
  }) : super(nom: nom, c1: c1, c2: c2, fotoPath: fotoPath);
}
