import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xml_fotos/presentation/widgets/curs.dart';
import 'package:xml_fotos/presentation/widgets/new_curs_riverpod.dart';

import '../../shared/utils/dialog.dart';
import '../providers/cursos_notifier.dart';
import '../providers/selection.dart';

class CursosScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cursosAsync = ref.watch(cursosNotifierProvider);
    final seleccionats = ref.watch(seleccioCursosProvider);

    return Scaffold(
      appBar: AppBar(
        title: seleccionats.isEmpty
            ? Text('Cursos')
            : Text('${seleccionats.length} seleccionats'),
        actions: [
          if (seleccionats.isNotEmpty)
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                final confirmat = await showConfirmacioEliminacioDialog(
                  context: context,
                  titol: 'Eliminar cursos',
                  missatge:
                  'Estàs segur que vols eliminar aquests cursos?',
                );
                if (confirmat == true) {
                  final cursos = ref.read(cursosNotifierProvider).value;
                  final aEliminar = cursos!
                      .where((c) => seleccionats.contains(c.id))
                      .toList();
                  await ref
                      .read(cursosNotifierProvider.notifier)
                      .eliminarCursos(aEliminar);
                  ref.read(seleccioCursosProvider.notifier).clear();
                }
              },
            ),
        ],
      ),
      body: cursosAsync.when(
        data: (cursos) => ListView.builder(
          itemCount: cursos.length,
          itemBuilder: (context, index) {
            final curs = cursos[index];
            return CursWidget(cursId: curs.id!);
          },
        ),
        loading: () => Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
      floatingActionButton: NewCursR(provider: cursosNotifierProvider),
    );
  }
}
