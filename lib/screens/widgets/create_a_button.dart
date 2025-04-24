import 'package:flutter/material.dart';

import '../../models/usuari.dart';
import '../data.dart';

class CreateButton extends StatelessWidget {
  final bool isAlumne;
  final Function(Usuari) onNouUsuari;

  const CreateButton({
    super.key,
    required this.isAlumne,
    required this.onNouUsuari,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        final resultat = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DataScreen(isAlumne: isAlumne),
          ),
        );

        if (resultat != null && resultat is Usuari) {
          onNouUsuari(resultat);
        }
      },
      child: const Icon(Icons.add),
      tooltip: 'Afegir ${isAlumne ? "alumne" : "professor"}',
    );
  }
}
