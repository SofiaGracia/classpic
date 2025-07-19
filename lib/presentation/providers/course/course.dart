import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xml_fotos/application/services/saf_methods.dart';
import 'package:xml_fotos/presentation/providers/course/repository.dart';

import '../../../data/repository/course_db.dart';
import '../../../domain/entities/course.dart';
import '../../../shared/utils/constants.dart';
import '../uri_notifier.dart';

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

      final uri = await ref.read(UriProvider.notifier).getUri();
      final message = await PlatformChannel.renameFolder(
          newName: newName,
          uri: uri!,
          tipusUsuari: alumnesFolder,
          grup: current.name);
      await _repo.editarCursDB(updated);

      state = AsyncData(updated);
    } catch (e, st) {
      rethrow; // re-llença perquè l’UI el pugui gestionar
    }
  }
}

final cursWidgetNotifierProvider = AsyncNotifierProvider.autoDispose
    .family<CourseWidgetNotifier, Course, int>(CourseWidgetNotifier.new);
