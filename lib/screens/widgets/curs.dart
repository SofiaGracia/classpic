import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xml_fotos/models/fotopathcacheext.dart';

import '../../models/alumne.dart';
import '../../models/usuari.dart';
import '../../providers/alumne_notifier.dart';
import '../../providers/cursos_notifier.dart';
import '../../service/storage_service.dart';
import '../llista_usuaris_riverpod.dart';
import 'counter.dart';

class CursWidget extends ConsumerStatefulWidget {
  final int cursId;

  const CursWidget({required this.cursId, super.key});

  @override
  ConsumerState<CursWidget> createState() => _CursWidgetState();
}

class _CursWidgetState extends ConsumerState<CursWidget> {
  bool isEditing = false;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final curs = ref
        .read(cursosNotifierProvider)
        .value
        ?.firstWhere((c) => c.id == widget.cursId);
    _controller = TextEditingController(text: curs?.nom ?? '');
  }

  @override
  Widget build(BuildContext context) {
    final curs = ref
        .watch(cursosNotifierProvider)
        .value
        ?.firstWhere((c) => c.id == widget.cursId);
    if (curs == null) return SizedBox.shrink();

    return GestureDetector(
        onTap: () {
          // Navegar a una altra pantalla
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LlistaUsuarisR<Alumne>(
                provider: alumnesPerCursFiltratProvider(widget.cursId),
                onEditar: (a) async {
                  await ref.read(alumnesNotifierProvider.notifier).editarAlumne(a);
                  await a.setFotoPathIfNeeded(ref.read(StorageServiceProvider));
                },
                onBorrar: (a) async => await ref.read(alumnesNotifierProvider.notifier).eliminarAlumne(a),
                onCreate: (a) async => await ref.read(alumnesNotifierProvider.notifier).inserirAlumne(a),
              ),
            ),
          );
        },
        child: ListTile(
          title: isEditing
              ? TextField(
                  controller: _controller,
                  /*onSubmitted: (value) {
                    ref.read(cursosNotifierProvider.notifier).editarCurs(
                          curs.copyWith(nom: value),
                        );
                    setState(() => isEditing = false);
                  },*/
                )
              : Text(curs.nom),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CounterWidget<Alumne>(
                provider: alumnesPerCursFiltratProvider(widget.cursId),
              ),
              IconButton(
                icon: Icon(isEditing ? Icons.check : Icons.edit),
                  onPressed: () async {
                    if (isEditing) {
                      final storageService = ref.read(StorageServiceProvider);
                      try {
                        await storageService.renombraCarpetaCurs(curs.nom, _controller.text);

                        // Actualitza el nom del curs en la base de dades
                        await ref.read(cursosNotifierProvider.notifier)
                            .editarCurs(curs.copyWith(nom: _controller.text));

                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Nom del curs actualitzat correctament.')),
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

                    // Sempre canviem l'estat (no cal que siga async)
                    setState(() {
                      isEditing = !isEditing;
                    });
                  }
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  ref.read(cursosNotifierProvider.notifier).eliminarCurs(curs);
                  ref.read(StorageServiceProvider).eliminarFotosCarpetaCurs(curs.nom);
                },
              ),
            ],
          ),
        )
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
