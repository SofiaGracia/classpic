import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xml_fotos/screens/widgets/create_a_button.dart';
import 'package:xml_fotos/screens/widgets/llista_usuaris.dart';
import 'package:xml_fotos/screens/widgets/usuari.dart';

import '../models/alumne.dart';
import '../models/professor.dart';
import '../models/usuari.dart';
import '../providers/usuaris.dart';
import 'data.dart';

enum TipusUsuari { alumne, professor }

class LlistaUsuarisScreen extends StatefulWidget {
  final String? grup;
  final TipusUsuari tipus;

  const LlistaUsuarisScreen({
    super.key,
    required this.grup,
    required this.tipus,
  });

  @override
  State<LlistaUsuarisScreen> createState() => _LlistaUsuarisScreenState();
}

class _LlistaUsuarisScreenState extends State<LlistaUsuarisScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UsuarisProvider>(context);
    final llista = widget.tipus == TipusUsuari.alumne
        ? provider.getAlumnesDelGrup(widget.grup!)
        : provider.professors;

    void afegirUsuariNou(Usuari nou) {
      provider.insertarUsuari(nou);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuari afegit correctament!')),
      );
    }

    void editarUsuari(Usuari modificat) {
      provider.editarUsuari(modificat);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuari actualitzat!')),
      );
    }

    void eliminarUsuari(Usuari usuari) {
      provider.eliminarUsuari(usuari);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuari eliminat.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tipus == TipusUsuari.alumne
            ? widget.grup!
            : 'Llista de professors'),
      ),
      body: LlistaUsuarisWidget(
        usuaris: llista,
        isAlumne: widget.tipus == TipusUsuari.alumne,
        onEditar: (usuari) async {
          final resultat = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DataScreen(
                usuari: usuari,
                isAlumne: widget.tipus == TipusUsuari.alumne,
              ),
            ),
          );
          if (resultat != null) editarUsuari(resultat);
        },
        onEliminar: eliminarUsuari,
      ),
      floatingActionButton: CreateButton(
        isAlumne: widget.tipus == TipusUsuari.alumne,
        onNouUsuari: afegirUsuariNou,
      ),
    );
  }
}
