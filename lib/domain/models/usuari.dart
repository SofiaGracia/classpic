abstract class Usuari {

  String get usuId;

  String nom;
  String c1;
  String? c2;
  String? fotoPath; // Ací només guardarem temporalment el path generat

  // Afegim _fotoPathHash per a la lògica del cache
  String? fotoPathHash;

  Usuari({required this.nom, required this.c1, this.c2, this.fotoPath});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Usuari &&
        other.usuId == usuId &&
        other.nom == nom &&
        other.c1 == c1 &&
        other.c2 == c2 &&
        other.fotoPath == fotoPath &&
        runtimeType == other.runtimeType;
  }

  @override
  int get hashCode => Object.hash(usuId, nom, c1, c2, fotoPath, runtimeType);
}
