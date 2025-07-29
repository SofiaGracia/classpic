
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:classpic/data/repository/course_db.dart';
import 'package:classpic/presentation/providers/course/repository.dart';

import '../../../domain/entities/course.dart';

class CoursesIdsNotifier extends AsyncNotifier<List<int>> {

  CourseRepository get _repo => ref.watch(courseRepositoryProvider);

  Future<List<int>> _fetchIds() async {
    return await _repo.getAllCoursesIds();
  }

  @override
  Future<List<int>> build() async {
    return _fetchIds();
  }

  Future<void> addCourse(Course c) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repo.insertarCursDB(c);
      return _fetchIds();
    });
  }

  Future<void> addCourses(List<Course> c) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repo.inserirCursosDB(c);
      return _fetchIds();
    });
  }

  Future<void> removeCourse(Course c) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repo.eliminarCursDB(c);
      return _fetchIds();
    });
  }

  Future<void> removeCourses(List<Course> c) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repo.eliminarCursosDB(c);
      return _fetchIds();
    });
  }

  Future<void> cleanCourses() async {
    try {
      final repo = await _repo;
      await repo.buidarCursosBD(); // Elimina de la BD
      state = AsyncData(<int>[]);   // Reflecteix-ho a l’estat
    } catch (e, st) {
      state = AsyncError(e, st);     // Gestiona errors
    }
  }
}

final coursesIdsProvider = AsyncNotifierProvider< CoursesIdsNotifier, List<int>>((){
  return CoursesIdsNotifier();
});