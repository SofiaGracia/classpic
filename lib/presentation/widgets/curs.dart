import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xml_fotos/presentation/providers/curs_widget.dart';

import '../../domain/entities/alumne.dart';
import '../../domain/entities/curs.dart';
import '../../shared/utils/dialog.dart';
import '../providers/alumne_notifier.dart';
import '../screens/llista_3.dart';
import '../screens/llista_usuaris_riverpod.dart';
import 'counter.dart';

//Creació d'un StateProvider global que guarda l'id del curs en edició
//La veritat és que és brutal que ho puga fer el provider
final cursEnEdicioProvider = StateProvider<int?>((ref) => null);

class CursWidget extends ConsumerStatefulWidget {
  final Curs cursPassat;
  final bool seleccionat;
  final VoidCallback? onLongPress;
  final Future<void> Function(Curs curs) onDelete;

  const CursWidget({
    required this.cursPassat,
    required this.onDelete,
    this.seleccionat = false,
    this.onLongPress,
  });

  @override
  ConsumerState<CursWidget> createState() => _CursWidgetState();
}

class _CursWidgetState extends ConsumerState<CursWidget> {
  bool isEditing = false;
  late TextEditingController _controller;
  late Curs curs;

  @override
  void initState() {
    super.initState();
    curs = widget.cursPassat;
    _controller = TextEditingController(text: widget.cursPassat.nom);
  }

  @override
  Widget build(BuildContext context) {
    _controller = TextEditingController(text: widget.cursPassat.nom);
    final curs = widget.cursPassat; // ús directe
    final cursAsync = ref.watch(cursWidgetNotifierProvider(curs.id!));
    final cursNot = ref.read(cursWidgetNotifierProvider(curs.id!).notifier);

    return cursAsync.when(
        data: (curs) => GestureDetector(
              onTap: () async {
                final llistaUsuaris = await ref
                    .read(alumnesNotifierProvider.notifier)
                    .getAlumnesPerCurs(curs.id!);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LlistaUsuarisR<Alumne>(
                      curs: curs,
                      isAlumne: true,
                      initialLlista: llistaUsuaris,
                    ),
                  ),
                );
              },
              child: ListTile(
                title: isEditing
                    ? TextField(
                        controller: _controller,
                        autofocus: true,
                        onSubmitted: (_) => _guardarNom(cursNot),
                      )
                    : Text(curs.nom),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CounterWidget<Alumne>(
                      provider: alumnesFiltratsCursProvider(curs.id),
                    ),
                    IconButton(
                      icon: Icon(isEditing ? Icons.check : Icons.edit),
                      onPressed: () => _onEditTap(cursNot),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        final confirmat = await showConfirmacioDialog(
                          context: context,
                          titol: 'Eliminar curs',
                          botoConfirmar: 'Si, eliminar',
                          missatge:
                              'Estàs segur que vols eliminar aquest curs?',
                        );
                        if (confirmat == true) {
                          //await cursNot.eliminarCurs(curs);
                          await widget.onDelete(widget.cursPassat);
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
            ),
        error: (e, _) => Card(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [Expanded(child: Text('Error $e'))],
                ),
              ),
            ),
        loading: () => Card(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    CircularProgressIndicator(),
                  ],
                ),
              ),
            ));
  }

  void _onEditTap(CursWidgetNotifier controller) async {
    final idActualEnEdicio = ref.read(cursEnEdicioProvider);

    if (!isEditing && idActualEnEdicio != null && idActualEnEdicio != curs.id) {
      // Hi ha un altre curs en edició
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Primer acaba d’editar el curs actual.')),
      );
      return;
    }

    if (isEditing) {
      await _guardarNom(controller);
      ref.read(cursEnEdicioProvider.notifier).state = null;
    } else {
      ref.read(cursEnEdicioProvider.notifier).state = curs.id;
    }

    if (mounted) {
      setState(() {
        isEditing = !isEditing;
      });
    }
  }

  Future<void> _guardarNom(CursWidgetNotifier controller) async {
    final nouNom = _controller.text.trim();
    if (nouNom.isEmpty || nouNom == curs.nom) return;

    try {
      //Comprovar que existeix el nom abans d'actualitzar-lo
      await controller.actualitzaNom(nouNom);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Nom del curs actualitzat correctament.')),
        );
        //_controller.text = nouNom;
        setState(() {
          _controller.text = nouNom;
        });
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al renombrar la carpeta: $e')),
        );
      }
      _controller.text = curs.nom;
    }
  }

  @override
  void dispose() {
    if (ref.read(cursEnEdicioProvider) == curs.id) {
      ref.read(cursEnEdicioProvider.notifier).state = null;
    }
    _controller.dispose();
    super.dispose();
  }
}
