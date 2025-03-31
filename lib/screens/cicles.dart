import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xml_fotos/providers/info_xml.dart';

import 'alumnes.dart';

class CiclesScreen extends StatelessWidget {
  CiclesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var infoXMLProvider = Provider.of<InfoXMLProvider>(context);
    List<String> cursos = infoXMLProvider.obtindreCursos();

    return Scaffold(
      appBar: AppBar(title: const Text('Cursos')),
      body: cursos.isEmpty
          ? const Center(child: CircularProgressIndicator()) // Indicador de càrrega mentre es carreguen les dades
          : ListView.builder(
        itemCount: cursos.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(cursos[index]),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AlumnesScreen(grup: cursos[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
