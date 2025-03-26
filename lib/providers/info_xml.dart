
import 'package:flutter/material.dart';

import '../models/cicle.dart';
import '../models/grup.dart';
import '../repository/cursos.dart';

class InfoXMLProvider with ChangeNotifier {

  late Map<String, Map<String, Set<Grup>>> cursos = {};
  late List<Cicle> cicles = [];

  InfoXMLProvider(){
    _carregaInfoXML();
  }

  // Funció per carregar les dades des del fitxer XML
  void _carregaInfoXML() async {
    cursos = await RepositoryCursosXML.carregaInfo();
    cursos.forEach((cicle, modalitats) {
      cicles.add(Cicle.fromAlgo(cicle, modalitats));
    });

    notifyListeners();
  }

  // Mètodes per obtenir cicles, modalitats i grups
  List<String> obtenirNomCicles() {
    return cursos.keys.toList();
  }

  List<Cicle> obtenirCicles() {
    return cicles;
  }

  Map<String, Map<String, Set<Grup>>> obtenirCursos(){
    return cursos;
  }

  List<String> obtenirModalitats(String cicle) {
    return cursos[cicle]?.keys.toList() ?? [];
  }

  //List<String> obtenirGrups(String cicle, String modalitat) {
  //  return cursos[cicle]?[modalitat]?.toList() ?? [];
  //}

  void mostrarInfo() {
    cursos.forEach((tipus, modalitats) {
      print("$tipus:");
      modalitats.forEach((modalitat, grups) {
        print("  $modalitat: ${grups.toList()}");
      });
    });
  }
}
