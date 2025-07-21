import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xml_fotos/presentation/providers/course/course.dart';
import 'package:xml_fotos/presentation/screens/users_list.dart';
import 'package:xml_fotos/shared/utils/dialog/uri.dart';
import 'package:xml_fotos/shared/utils/enum/rename_folder_error.dart';

import '../../domain/entities/student.dart';
import '../../domain/entities/course.dart';
import '../../shared/utils/dialog/delete.dart';
import '../providers/student/stream.dart';
import '../providers/student/student_ids_async.dart';
import 'counter.dart';

//Creació d'un StateProvider global que guarda l'id del curs en edició
final cursEnEdicioProvider = StateProvider<int?>((ref) => null);

class CourseWidget extends ConsumerStatefulWidget {
  final Course coursePassed;
  final Future<void> Function(Course curs) onDelete;

  const CourseWidget({
    required this.coursePassed,
    required this.onDelete,
  });

  @override
  ConsumerState<CourseWidget> createState() => _CursWidgetState();
}

class _CursWidgetState extends ConsumerState<CourseWidget> {
  bool isEditing = false;
  late TextEditingController _controller;
  late Course course;

  @override
  void initState() {
    super.initState();
    course = widget.coursePassed;
    _controller = TextEditingController(text: course.name);
  }

  Future<void> _saveCourseName(CourseWidgetNotifier controller) async {
    final nouNom = _controller.text.trim();
    if (nouNom.isEmpty || nouNom == course.name) return;

    try {
      //Comprovar que existeix el nom abans d'actualitzar-lo
      await controller.updateCourse(nouNom);
      setState(() {
        course = course.copyWith(name: nouNom);
      });

      if (context.mounted) {
        DialogHelper.mostrarSnackBar(
            context, 'Nom del curs actualitzat correctament');
      }
    } on PlatformException catch (e) {
      String error;

      switch (e.code) {
        case ErrorRenameFolder.noDestination:
          error = 'No s’ha trobat la carpeta que vols renombrar.';
          break;
        case ErrorRenameFolder.noParent:
          error = 'No s’ha pogut accedir a la carpeta superior.';
          break;
        case ErrorRenameFolder.folderExists:
          error = 'Ja existix una altra carpeta amb este nom.';
          break;
        case ErrorRenameFolder.writeError:
          error =
              'No s’ha pogut renombrar la carpeta. Comprova els permisos o torna-ho a intentar.';
          break;
        case ErrorRenameFolder.folderInvalid:
          error = 'La carpeta seleccionada no és vàlida.';
          break;
        case ErrorRenameFolder.copyFailed:
          error = 'No s’han pogut copiar els fitxers a la nova carpeta.';
          break;
        default:
          error = 'S’ha produït un error inesperat: ${e.message}';
      }

      if (context.mounted) {
        DialogHelper.mostrarSnackBar(context, error);
      }

      _controller.text = course.name;
    }
  }

  void _onEditTap(CourseWidgetNotifier controller) async {
    final idActualEnEdicio = ref.read(cursEnEdicioProvider);

    if (!isEditing &&
        idActualEnEdicio != null &&
        idActualEnEdicio != course.id) {
      // Hi ha un altre curs en edició
      DialogHelper.mostrarSnackBar(
          context, 'Primer acaba d’editar el curs actual.');
      return;
    }

    if (isEditing) {
      await _saveCourseName(controller);
      ref.read(cursEnEdicioProvider.notifier).state = null;

    } else {
      ref.read(cursEnEdicioProvider.notifier).state = course.id;
    }

    if (mounted) {
      setState(() {
        isEditing = !isEditing;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cursAsync = ref.watch(cursWidgetNotifierProvider(course.id!));
    final cursNot = ref.read(cursWidgetNotifierProvider(course.id!).notifier);

    return cursAsync.when(
        data: (curs) => GestureDetector(
              onTap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UsersListScreen<Student>(
                      curs: curs,
                    ),
                  ),
                );
              },
              child: ListTile(
                key: ValueKey(course.id),
                title: isEditing
                    ? TextField(
                        controller: _controller,
                        autofocus: true,
                        onSubmitted: (_) => _saveCourseName(cursNot),
                      )
                    : Text(curs.name),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CounterWidget<Student>(
                      totalBuilder: (ref) => studentIdsProvider(course.id!),
                      withPhoto: studentCourseHasPhotoStreamProvider(course.id!),
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
                              'Estàs segur que vols eliminar aquest curs? S\'eliminaran els alumnes a dins del curs',
                        );
                        if (confirmat == true) {
                          await widget.onDelete(widget.coursePassed);
                          DialogHelper.mostrarSnackBar(
                              context, 'Curs eliminat.');
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

  @override
  void dispose() {
    if (ref.read(cursEnEdicioProvider) == course.id) {
      ref.read(cursEnEdicioProvider.notifier).state = null;
    }
    _controller.dispose();
    super.dispose();
  }
}
