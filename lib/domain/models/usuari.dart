abstract class Usuari {

  String get usuId;

  String nom;
  String c1;
  String? c2;

  // Afegim _fotoPathHash per a la lògica del cache
  String? fotoPathHash;

  //S'utilitzarà per a contar quants usuaris tenen foto
  bool hasFoto;

  Usuari({required this.nom, required this.c1, this.c2, this.fotoPathHash, required this.hasFoto});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Usuari &&
        other.usuId == usuId &&
        other.nom == nom &&
        other.c1 == c1 &&
        other.c2 == c2 &&
        other.fotoPathHash == fotoPathHash &&
        other.hasFoto == hasFoto &&
        runtimeType == other.runtimeType;
  }

  @override
  int get hashCode => Object.hash(usuId, nom, c1, c2, fotoPathHash, hasFoto, runtimeType);
}
