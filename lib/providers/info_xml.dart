
import 'package:flutter/material.dart';
import 'package:xml_fotos/utils/carpeta.dart';
import '../repository/cursos.dart';

class InfoXMLProvider with ChangeNotifier {

  late var cursos = <String>[];

  InfoXMLProvider(){
    _carregaInfoXML();
  }

  void _carregaInfoXML() async {
    cursos = await RepositoryCursos.carregaInfo();
    await GestorCarpetes.inicialitzarCarpetes(cursos);
    notifyListeners();
  }

  List<String> obtindreCursos() {
    return cursos;
  }
}
