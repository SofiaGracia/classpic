import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xml_fotos/screens/widgets/create_button.dart';
import 'package:xml_fotos/screens/widgets/usuari.dart';

import '../models/alumne.dart';
import '../models/professor.dart';
import '../models/usuari.dart';
import '../providers/usuaris.dart';
import 'data.dart';

class LlistaUsuarisScreen extends StatefulWidget {
  final String tipus; // 'alumnes' o 'professors'

  const LlistaUsuarisScreen({super.key, required this.tipus});

  @override
  State<LlistaUsuarisScreen> createState() => _LlistaUsuarisScreenState();
}

class _LlistaUsuarisScreenState extends State<LlistaUsuarisScreen> {
  @override
  Widget build(BuildContext context) {
    final usuarisProvider = Provider.of<UsuarisProvider>(context);

    final llista = widget.tipus == 'alumnes'
        ? usuarisProvider.alumnes
        : usuarisProvider.professors;

    void afegirUsuariNou(Usuari nou) {
      usuarisProvider.insertarUsuari(nou);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tipus == 'alumnes' ? 'Llista d\'alumnes' : 'Llista de professors'),
      ),
      body:ListView.builder(
        itemCount: llista.length,
        itemBuilder: (context, index) {
          final usuari = llista[index];

          return UsuariTile(
              primerCognom: usuari.c1,
              segonCognom: usuari.c2??'',
              nom: usuari.nom,
              identificador: widget.tipus == 'alumnes'? (usuari as Alumne).nia: (usuari as Professor).dni,
              foto: usuari.fotoPath != null? usuari.fotoPath as Uint8List : null,
              onEditar: () async {
                final resultat = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DataScreen(
                      usuari: usuari, // pot ser Alumne o Professor
                      isAlumne: widget.tipus == 'alumnes',
                    ),
                  ),
                );

                if (resultat != null) {
                  // Si tornes l'usuari modificat des de DataScreen
                  usuarisProvider.editarUsuari(resultat);
                }
              },
              onEliminar:  () => usuarisProvider.eliminarUsuari(usuari)
          );
        },
      ),
      floatingActionButton: CreateButton(
        isAlumne: widget.tipus == 'alumnes' ? true : false,
        onNouUsuari: afegirUsuariNou,
      ),
    );
  }
}
