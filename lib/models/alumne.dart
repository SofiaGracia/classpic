class Alumne {
  String nia; //Ha de tindre 10 caràcters
  String nom;
  String c1;
  String? c2;
  String? grup;
  String? fotoPaht;

  Alumne({
    required this.nia,
    required this.nom,
    required this.c1,
    this.c2,
    this.grup,
    this.fotoPaht
  });

  //En el cas de crear un nou alumne i que este no tinga nia se li ha de posar un codi tipus: AAA0000000 (Ha de tindre 10 caràcters)
}
