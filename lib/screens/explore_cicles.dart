
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xml_fotos/providers/info_xml.dart';
import 'package:xml_fotos/repository/info_xml.dart';
import 'package:xml_fotos/screens/widgets/my_circular_progress_indicator.dart';
import 'package:xml_fotos/providers/carpeta.dart';

import '../models/carpeta.dart';
import '../models/cicle.dart';
import '../models/grup.dart';
import '../models/modalitat.dart';
import 'alumnes.dart';

class CiclesScreen extends StatelessWidget {

  CiclesScreen({super.key});

  @override
  Widget build(BuildContext context) {

    var infoXMLProvider = Provider.of<InfoXMLProvider>(context);
    List<Cicle> cicles = infoXMLProvider.obtenirCicles();

    var carpetaProvider = Provider.of<CarpetaProvider>(context);
    final Map<String, Carpeta> carpetes = carpetaProvider.obtenirTotes();

    print(carpetes);

    return Scaffold(
      appBar: AppBar(title: const Text('Cursos')),
      body: Center(child: _creaLlistaCicles(cicles)),
    );
  }
}
//Ha de ser una llista de Cicles no de String
_creaLlistaCicles(List<Cicle> cicles){
  if (cicles.isEmpty) {
    // Si la llista és nul·la retornem un indicador de progrés
    return MyCircularProgressIndicator();
  } else {
    return ListView.builder(
      itemCount: cicles.length,
      itemBuilder: (BuildContext context, int index) {
        return CicleExpansionTile(
          key: PageStorageKey(cicles[index].nom), // Manté l'estat del tile
          nom_cicle: cicles[index].nom,
          llista: cicles[index].llistaModalitats,
        );
      },
    );
  }
}

List<Widget> _creaLlistaTiles(BuildContext context, List<Grup> llista) {
  return llista.map((grup) => ListTile(
    title: Text(grup.nom),
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AlumnesScreen(grup: grup,), // Passa el paràmetre si cal
        ),
      );
    },
  )).toList();
}



List<Widget> _creaLlistaExpansionTile(BuildContext context, List<Modalitat> llista){

  return llista
      .map((modalitat) => ExpansionTile(
    key: PageStorageKey(modalitat.nom), // Manté l'estat del tile
    title: Text(modalitat.nom),
    children: _creaLlistaTiles(context, modalitat.llistaGrups),
  ))
      .toList();
}

class CicleExpansionTile extends StatelessWidget {
  final String nom_cicle;
  final List<Modalitat>? llista;

  CicleExpansionTile({super.key, required this.nom_cicle, required this.llista});

  @override
  Widget build(BuildContext context) {

    return llista != null?

    ExpansionTile(
      title: Text(nom_cicle),
      children: _creaLlistaExpansionTile(context, llista!)
    ):ListTile(title: Text(nom_cicle));
  }
}