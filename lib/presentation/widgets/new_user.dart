

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/alumne.dart';
import '../../domain/entities/professor.dart';
import '../../domain/models/usuari.dart';
import '../screens/new_edit_user.dart';

class NewUserR<T extends Usuari> extends StatelessWidget {
  final bool isAlumne;
  final Future<void> Function(Usuari usuari) onCreate;
  final String Function(T usuari) getId;
  final T Function({
  required String id,
  required String nom,
  required String c1,
  required String c2,
  String? fotoPath,
  String? grup
  }) constructor;

  const NewUserR({
    super.key,
    required this.isAlumne,
    required this.onCreate,
    required this.getId,
    required this.constructor,
  });

  Future<void> _crearUsuari(BuildContext context) async {
    final nouUsuari = await Navigator.push<Usuari>(
      context,
      MaterialPageRoute(
        builder: (_) => NewEditUserScreen<T>(
          usuari: null,
          getId: getId,
          constructor: constructor,
          isAlumne: isAlumne,
        ),
      ),
    );

    if (nouUsuari != null) {
      await onCreate(nouUsuari);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _crearUsuari(context),
      child: const Icon(Icons.add),
      tooltip: 'Afegir usuari',
    );
  }
}