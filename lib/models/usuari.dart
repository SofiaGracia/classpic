class Usuari {
  String nom;
  String c1;
  String? c2;
  String? fotoPath;

  Usuari({
    required this.nom,
    required this.c1,
    this.c2,
    this.fotoPath,
  });
}
