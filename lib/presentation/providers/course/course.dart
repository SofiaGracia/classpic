import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xml_fotos/presentation/providers/course/repository.dart';

import '../../../data/repository/course_db.dart';
import '../../../domain/entities/course.dart';

class CourseWidgetNotifier extends AutoDisposeFamilyAsyncNotifier<Course, int> {

  CourseRepository get _repo => ref.watch(courseRepositoryProvider);

  @override
  FutureOr<Course> build(int id) async {
    final curs = await _repo.carregaCursDB(id);
    return curs!;
  }

  Future<void> updateCourse(String newName) async {
    try {

      //Ací també s'actualitza el nom del grup en els alumnes d'eixe grup.
      //pq canviem el nom però no l'id del curs
      final current = state.value as Course;
      final updated = current.copyWith(id: current.id, name: newName);


      /*final cursActualitzat = await ref.read(cursosNotifierProvider.notifier)
          .actualitza(updated);

      if (cursActualitzat == null) {
        throw Exception('No s\'ha pogut actualitzar el nom del curs.');
      }*/

      await _repo.editarCursDB(updated);

      //També ho podries fer en el provider però bueno...
      //final repoStorage = StorageService();
      //repoStorage.renombraCarpetaCurs(curs.nom, nouNom);

      state = AsyncData(updated);
    } catch (e, st) {
      rethrow; // re-llença perquè l’UI també el pugui gestionar
    }
  }
}

final cursWidgetNotifierProvider = AsyncNotifierProvider.autoDispose
    .family<CourseWidgetNotifier, Course, int>(CourseWidgetNotifier.new);
