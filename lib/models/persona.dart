class PersonaBase {
  final String nom;
  final String c1;
  final String? c2;
  final String? fotoPath;

  PersonaBase({
    required this.nom,
    required this.c1,
    this.c2,
    this.fotoPath,
  });
}
