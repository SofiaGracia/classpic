abstract class Usuari {
  String nom;
  String c1;
  String? c2;
  String? fotoPath; // Ací només guardarem temporalment el path generat

  // Afegim _fotoPathHash per a la lògica del cache
  String? fotoPathHash;

  Usuari({required this.nom, required this.c1, this.c2, this.fotoPath});
}
