import 'foto_info.dart';

abstract class Usuari {

  String get usuId;

  String nom;
  String c1;
  String? c2;

  // Afegim _fotoPathHash per a la lògica del cache
  String? fotoPathHash;

  String fotoFolder;
  String? fotoFilename;

  Usuari({required this.nom, required this.c1, this.c2, this.fotoPathHash, required this.fotoFolder, this.fotoFilename});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Usuari &&
        other.usuId == usuId &&
        other.nom == nom &&
        other.c1 == c1 &&
        other.c2 == c2 &&
        other.fotoPathHash == fotoPathHash &&
        other.fotoFolder == fotoFolder &&
        other.fotoFilename == fotoFilename &&
        runtimeType == other.runtimeType;
  }

  /// Getter opcional per reconstruir FotoInfo al vol
  FotoInfo? get fotoInfo =>
      (fotoFilename != null)
          ? FotoInfo(folder: fotoFolder, filename: fotoFilename!)
          : null;

  @override
  int get hashCode => Object.hash(usuId, nom, c1, c2, fotoPathHash, fotoFolder, fotoFilename, runtimeType);
}
