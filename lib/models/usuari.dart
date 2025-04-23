class Usuari {
  final String nom;
  final String c1;
  final String? c2;
  final String? fotoPath;

  Usuari({
    required this.nom,
    required this.c1,
    this.c2,
    this.fotoPath,
  });
}
