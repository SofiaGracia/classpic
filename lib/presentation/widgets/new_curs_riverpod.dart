import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xml_fotos/presentation/providers/course/repository.dart';

import '../../domain/entities/course.dart';

class NewCursR extends ConsumerWidget {
  final Future<void> Function(Course curs) onCreate;

  const NewCursR({required this.onCreate});

  String crearGrupSenseNom(Set<String> nomsCursos) {
    String nomBase = 'nou grup';
    int index = 0;
    String nomFinal = nomBase;
    while (nomsCursos.contains(nomFinal)) {
      index++;
      nomFinal = '$nomBase ($index)';
    }
    return nomFinal;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FloatingActionButton(
      onPressed: () async {
        final controlador = TextEditingController();
        final cursos = await ref.read(courseRepositoryProvider).carregarCursosDB();
        final nomsExistents = cursos.map((c) => c.name.toLowerCase()).toSet();

        final nom = await showDialog<String>(
          context: context,
          builder: (context) {
            final nomFinal = crearGrupSenseNom(nomsExistents);
            controlador.text = nomFinal;

            return AlertDialog(
              title: const Text('Nom del nou curs'),
              content: TextField(
                controller: controlador,
                decoration: const InputDecoration(
                  hintText: 'Introdueix el nom del curs',
                ),
                autofocus: true,
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    //controlador.dispose();
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel·la'),
                ),
                TextButton(
                  onPressed: () {
                    final nomIntrod = controlador.text.trim();
                    if (nomIntrod.isEmpty ||
                        nomsExistents.contains(nomIntrod.toLowerCase())) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Nom no vàlid o ja existent')),
                      );
                    } else {
                      Navigator.pop(context, nomIntrod); // Retorna el nom
                    }
                  },
                  child: const Text('Crea'),
                ),
              ],
            );
          },
        );

        if (nom != null) {
          final nouCurs = Course(name: nom);
          onCreate(nouCurs);
        }
      },
      child: const Icon(Icons.add),
      tooltip: 'Afegir curs',
    );
  }
}
