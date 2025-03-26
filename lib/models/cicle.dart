import 'grup.dart';
import 'modalitat.dart';

class Cicle {
  late String nom;
  //Despres té una llista de modalitats
  late List<Modalitat> llistaModalitats = [];

  Cicle.fromAlgo(String nom_cicle, Map<String, Set<Grup>> modalitats){
    nom = nom_cicle;
    modalitats.forEach((modalitat, grups) {

      //Ací gastarem el de Modalitat.fromAlgo
      llistaModalitats.add(Modalitat.fromAlgo(modalitat, grups));
    });
  }
}