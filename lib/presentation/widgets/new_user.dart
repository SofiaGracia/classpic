import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/services/codi_generator.dart';
import '../../domain/models/usuari.dart';
import '../providers/alumne_notifier.dart';
import '../providers/professor_notifier.dart';
import '../screens/new_edit_user.dart';

class NewUserR<T extends Usuari> extends ConsumerWidget {
  final bool isAlumne;
  final Future<void> Function(Usuari usuari) onCreate;
  final String Function(T usuari) getId;
  final T Function(
      {required String id,
      required String nom,
      required String c1,
      required String c2,
      String? fotoPath,
      String? grup}) constructor;

  //late String codiUsuari;

  NewUserR({
    super.key,
    required this.isAlumne,
    required this.onCreate,
    required this.getId,
    required this.constructor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FloatingActionButton(
      onPressed: () async {
        final codiUsuari = await CodiGenerator.generaCodi(
            isAlumne: isAlumne,
            existeixFunc: (codi) async {
              return isAlumne
                  ? await ref
                      .read(alumnesNotifierProvider.notifier)
                      .existeixNia(codi)
                  : await ref
                      .read(professorNotifierProvider.notifier)
                      .existeixDni(codi);
            });

        final nouUsuari = await Navigator.push<Usuari>(
          context,
          MaterialPageRoute(
            builder: (_) => NewEditUserScreen<T>(
              usuari: null,
              getId: getId,
              constructor: constructor,
              isAlumne: isAlumne,
              codiUsuari: codiUsuari,
            ),
          ),
        );

        if (nouUsuari != null) {
          await onCreate(nouUsuari);
        }
      },
      child: const Icon(Icons.add),
      tooltip: 'Afegir usuari',
    );
  }
}
