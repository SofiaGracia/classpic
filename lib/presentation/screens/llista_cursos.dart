import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xml_fotos/presentation/widgets/curs.dart';
import 'package:xml_fotos/presentation/widgets/new_curs_riverpod.dart';

import '../../application/services/storage_service.dart';
import '../../domain/entities/curs.dart';
import '../../shared/utils/dialog.dart';
import '../providers/cursos_notifier.dart';
import '../providers/selection.dart';

class CursosScreen extends ConsumerStatefulWidget {
  const CursosScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<CursosScreen> createState() => _CursosScreenState();
}

class _CursosScreenState extends ConsumerState<CursosScreen> {
  List<Curs> _cursos = [];

  @override
  void initState(){
    super.initState();
    _loadLlista();
  }

  Future<void> _loadLlista() async {
    final cursos = await ref.read(cursosNotifierProvider.notifier).getCursosSenseModificarState();
    setState(() {
      _cursos = cursos;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cursos'),
      ),
      body: ListView.builder(
        itemCount: _cursos.length,
        itemBuilder: (context, index) {
          final cursSencer = _cursos[index];
          return CursWidget(
            curs: cursSencer,
            onDelete: (c) async {
              await ref.read(cursosNotifierProvider.notifier).eliminarCurs(c);
              setState(() {
                _loadLlista();
              });
            },
          );
        },
      ),
      floatingActionButton: NewCursR(
        provider: cursosNotifierProvider,
        onCreate: (c) async {
          await ref.read(cursosNotifierProvider.notifier).inserirCurs(c);
          final storage = ref.read(StorageServiceProvider);
          await storage.creaCarpetaGrup(c.nom);
          setState(() {
            _loadLlista();
          });
        },
      ),
    );
  }
}





/*class CursosScreenStl extends ConsumerWidget {

  List<Curs> _cursos = [];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cursosState = ref.watch(cursosNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Cursos'),
      ),
      body: cursosState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
        data: (llista) => ListView.builder(
          itemCount: llista.length,
          itemBuilder: (context, index) {
            final idCurs = llista[index].id!;
            return CursWidget(cursId: idCurs);
          },
        ),
      ),
      floatingActionButton: NewCursR(provider: cursosNotifierProvider),
    );
  }
  /*final cursos = ref.watch(cursosNotifierProvider.select(
          (state) => state.maybeWhen(
        data: (llista) => llista.map((c) => c.id!).toList(),
        orElse: () => [],
      ),
    ));
    //final seleccionats = ref.watch(seleccioCursosProvider);

    return Scaffold(
      appBar: AppBar(
          title: Text('Cursos')
        /*title: seleccionats.isEmpty
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
        ],*/
      ),
      body: ListView.builder(
          itemCount: cursos.length,
          itemBuilder: (context, index) {
            final idCurs = cursos[index];
            return CursWidget(cursId: idCurs);
          },
        ),
      floatingActionButton: NewCursR(provider: cursosNotifierProvider),
    );
  }*/
}
*/