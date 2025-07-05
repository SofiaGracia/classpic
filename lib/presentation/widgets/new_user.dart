import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xml_fotos/presentation/providers/cursos_notifier.dart';

import '../../application/services/codi_generator.dart';
import '../../domain/models/usuari.dart';
import '../providers/alumne_notifier.dart';
import '../providers/professor_notifier.dart';
import '../screens/create_edit_user.dart';
import '../screens/new_edit_user.dart';

class NewUserR<T extends Usuari> extends ConsumerWidget {
  final bool isAlumne;
  final Future<void> Function(Usuari usuari) onCreate;
  final int? cursId;
  final String Function(T usuari) getId;

  NewUserR({
    super.key,
    required this.isAlumne,
    required this.onCreate,
    required this.cursId,
    required this.getId,
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

        var nomDelGrupActual = null;

        if (isAlumne){

          final cursos = await ref.read(cursosNotifierProvider.notifier).getCursosSenseModificarState();

          nomDelGrupActual = cursos
              .firstWhere((c) => c.id.toString() == cursId.toString())
              .nom;
        }

        /*final nouUsuari = await Navigator.push<Usuari>(
          context,
          MaterialPageRoute(
            builder: (_) => NewEditUserScreen<T>(
              usuari: null,
              getId: getId,
              isAlumne: isAlumne,
              cursId: isAlumne? cursId: null,
              cursNom: nomDelGrupActual,
              codiUsuari: codiUsuari,
              imageUser: null,
            ),
          ),
        );*/

        final nouUsuari = await Navigator.push<Usuari>(
          context,
          MaterialPageRoute(
            builder: (_) => CreateEditUserScreen<T>(
              usuari: null,
              isAlumne: isAlumne,
              cursId: isAlumne? cursId: null,
              cursNom: nomDelGrupActual,
              codiUsuari: codiUsuari,
              uriImageUser: null,
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
