import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xml_fotos/presentation/providers/cursos_notifier.dart';

class CursosDropdown extends ConsumerStatefulWidget {
  final int cursId;
  final void Function(String grupNom) onGrupSeleccionat;

  const CursosDropdown(
      {super.key, required this.cursId, required this.onGrupSeleccionat});

  @override
  ConsumerState<CursosDropdown> createState() => _DropDownCursosState();
}

class _DropDownCursosState extends ConsumerState<CursosDropdown> {
  @override
  Widget build(BuildContext context) {
    final cursosAsync = ref.watch(cursosNotifierProvider);

    return cursosAsync.when(
        data: (cursos) {
          final cursTrobat = cursos.firstWhere((c) => c.id == widget.cursId);
          var valorSeleccionat = cursTrobat.id.toString();

          return DropdownButtonFormField<String>(
            value: valorSeleccionat,
            onChanged: (nouId) {
              if (nouId != null) {
                final cursSeleccionat =
                    cursos.firstWhere((c) => c.id.toString() == nouId);
                setState(() {
                  valorSeleccionat = cursSeleccionat.id.toString();
                });
                widget.onGrupSeleccionat(cursSeleccionat.nom);
              }
            },
            decoration: const InputDecoration(
              labelText: "Curs",
              border: OutlineInputBorder(),
            ),
            items: cursos.map((c) {
              return DropdownMenuItem<String>(
                value: c.id.toString(),
                child: Text(c.nom),
              );
            }).toList(),
          );
        },
        loading: () => const CircularProgressIndicator(),
        error: (e, _) => Text('Error carregant cursos: $e'));
  }
}
