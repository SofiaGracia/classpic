import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:classpic/domain/entities/course.dart';
import 'package:classpic/presentation/providers/course/courses_ids_async.dart';

class CursosDropdown extends ConsumerStatefulWidget {
  final int cursId;
  final void Function(String grupNom) onGrupSeleccionat;
  final List<Course>? courses;

  const CursosDropdown(
      {super.key, required this.cursId, required this.onGrupSeleccionat, required this.courses});

  @override
  ConsumerState<CursosDropdown> createState() => _DropDownCursosState();
}

class _DropDownCursosState extends ConsumerState<CursosDropdown> {
  @override
  Widget build(BuildContext context) {
    final cursosAsync = ref.watch(coursesIdsProvider);

    return cursosAsync.when(
        data: (ids) {
          final idTrobat = ids.firstWhere((id) => id == widget.cursId);
          var valorSeleccionat = idTrobat.toString();

          return DropdownButtonFormField<String>(
            value: valorSeleccionat,
            onChanged: (nouId) {
              if (nouId != null) {
                final idSeleccionat =
                    ids.firstWhere((id) => id.toString() == nouId);
                setState(() {
                  valorSeleccionat = idSeleccionat.toString();
                });

                //No tenim el nom del curs, tenim un mètode en el repo però és async
                final cursSeleccionat = widget.courses?.firstWhere((c) => c.id.toString() == nouId);

                widget.onGrupSeleccionat(cursSeleccionat!.name);
              }
            },
            decoration: const InputDecoration(
              labelText: "Curs",
              border: OutlineInputBorder(),
            ),
            items: widget.courses?.map((c) {
              return DropdownMenuItem<String>(
                value: c.id.toString(),
                child: Text(c.name),
              );
            }).toList(),
          );
        },
        loading: () => const CircularProgressIndicator(),
        error: (e, _) => Text('Error carregant cursos: $e'));
  }
}
