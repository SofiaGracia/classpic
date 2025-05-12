import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xml_fotos/service/storage_service.dart';

import '../../models/alumne.dart';
import '../../providers/alumne_notifier.dart';
import '../../providers/cursos_notifier.dart';
import '../llista_usuaris_riverpod.dart';

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
                onEditar: (a) async => await ref.read(alumnesNotifierProvider.notifier).editarAlumne(a),
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
              IconButton(
                icon: Icon(isEditing ? Icons.check : Icons.edit),
                  onPressed: () async {
                    if (isEditing) {
                      final nouNom = _controller.text.trim();
                      final storageService = ref.read(StorageServiceProvider);

                      try {
                        await storageService.renombraCarpetaCurs(curs.nom, nouNom);

                        await ref.read(cursosNotifierProvider.notifier)
                            .editarCurs(curs.copyWith(nom: nouNom));

                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Curs '$nouNom' actualitzat correctament.")),
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Error: $e")),
                          );
                        }
                      }
                    }

                    setState(() {
                      isEditing = !isEditing;
                    });
                  }
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  ref.read(cursosNotifierProvider.notifier).eliminarCurs(curs);
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
