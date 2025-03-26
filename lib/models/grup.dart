class Grup {
  late String nom;
  late String nom_complet;

  Grup.fromAlgo(String nom_grup, String nom_c) {
    nom = nom_grup;
    nom_complet = nom_c;
  }

  @override
  String toString() {
    //return 'Grup(nom: $nom, nom_complet: $nom_complet)';
    return '$nom_complet';
  }
}
