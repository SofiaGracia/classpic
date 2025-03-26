import 'grup.dart';

class Modalitat {
  late String nom;
  late List<Grup> llistaGrups = [];
  
  Modalitat.fromAlgo(String nom_modalitat, Set<Grup> grups){
    nom = nom_modalitat;
    grups.forEach((grup){
      llistaGrups.add(grup);
    });
  }
}