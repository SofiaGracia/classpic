import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xml_fotos/screens/widgets/usuari.dart';

import '../models/alumne.dart';
import '../models/professor.dart';
import '../providers/usuaris.dart';

class LlistaUsuaris extends StatefulWidget {
  final String tipus; // 'alumnes' o 'professors'

  const LlistaUsuaris({super.key, required this.tipus});

  @override
  State<LlistaUsuaris> createState() => _LlistaUsuarisState();
}

class _LlistaUsuarisState extends State<LlistaUsuaris> {
  @override
  Widget build(BuildContext context) {
    final usuarisProvider = Provider.of<UsuarisProvider>(context);

    final llista = widget.tipus == 'alumnes'
        ? usuarisProvider.alumnes
        : usuarisProvider.professors;

    return ListView.builder(
      itemCount: llista.length,
      itemBuilder: (context, index) {
        final usuari = llista[index];

        return UsuariTile(
            primerCognom: usuari.c1,
            segonCognom: usuari.c2??'',
            nom: usuari.nom,
            identificador: widget.tipus == 'alumnes'? (usuari as Alumne).nia: (usuari as Professor).dni,
            foto: usuari.fotoPath != null? usuari.fotoPath as Uint8List : null,
            onEditar:  () => usuarisProvider.editarUsuari(usuari),
            onEliminar:  () => usuarisProvider.eliminarUsuari(usuari)
        );
      },
    );
  }
}
