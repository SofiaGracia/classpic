import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xml_fotos/domain/models/fotopathcacheext.dart';

import '../../domain/entities/alumne.dart';
import '../../shared/utils/dialog.dart';
import '../providers/alumne_notifier.dart';
import '../providers/curs_controller.dart';
import '../providers/cursos_notifier.dart';
import '../../application/services/storage_service.dart';
import '../screens/llista_usuaris_riverpod.dart';
import 'counter.dart';

class CursWidget extends ConsumerStatefulWidget {
  final int cursId;
  final bool seleccionat;
  final VoidCallback? onLongPress;

  const CursWidget({
    required this.cursId,
    this.seleccionat = false,
    this.onLongPress,
  });

  @override
  ConsumerState<CursWidget> createState() => _CursWidgetState();
}

class _CursWidgetState extends ConsumerState<CursWidget> {
  bool isEditing = false;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final nomCurs = ref.read(CursControllerProvider(widget.cursId).notifier);
    _controller = TextEditingController(text: nomCurs.curs?.nom ?? '');
  }

  @override
  Widget build(BuildContext context) {
    // Nom del curs reactiu, només actualitza aquest widget quan canvia aquest valor
    final nom = ref.watch(
      cursosNotifierProvider.select((state) {
        return state.when(
          data: (llista) => llista.firstWhere((c) => c.id == widget.cursId).nom,
          loading: () => 'Carregant...',
          error: (_, __) => 'Error',
        );
      }),
    );

    //final estat = ref.watch(cursControllerProvider(widget.cursId));
    final controller = ref.read(CursControllerProvider(widget.cursId).notifier);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LlistaUsuarisR<Alumne>(
              provider: alumnesPerCursFiltratProvider(widget.cursId),
              onEditar: (a) async {
                await ref
                    .read(alumnesNotifierProvider.notifier)
                    .editarAlumne(a);
                await a.setFotoPathIfNeeded(ref.read(StorageServiceProvider));
              },
              onBorrar: (a) async => await ref
                  .read(alumnesNotifierProvider.notifier)
                  .eliminarAlumne(a),
              onCreate: (a) async => await ref
                  .read(alumnesNotifierProvider.notifier)
                  .inserirAlumne(a),
            ),
          ),
        );
      },
      child: ListTile(
        title: isEditing
            ? TextField(
                controller: _controller,
                autofocus: true,
                onSubmitted: (_) => _guardarNom(controller),
              )
            : Text(nom),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CounterWidget<Alumne>(
              provider: alumnesPerCursFiltratProvider(widget.cursId),
            ),
            IconButton(
              icon: Icon(isEditing ? Icons.check : Icons.edit),
              onPressed: () => _onEditTap(controller),
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                final confirmat = await showConfirmacioEliminacioDialog(
                  context: context,
                  titol: 'Eliminar curs',
                  missatge: 'Estàs segur que vols eliminar aquest curs?',
                );
                if (confirmat == true) {
                  await controller.eliminarCurs();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Curs eliminat.')),
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _onEditTap(CursController controller) async {
    if (isEditing) {
      await _guardarNom(controller);
    }

    setState(() {
      isEditing = !isEditing;
    });
  }

  Future<void> _guardarNom(CursController controller) async {
    final nouNom = _controller.text.trim();
    if (nouNom.isEmpty || nouNom == controller.curs?.nom) return;

    try {
      await controller.editarNom(nouNom);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Nom del curs actualitzat correctament.')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al renombrar la carpeta: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
