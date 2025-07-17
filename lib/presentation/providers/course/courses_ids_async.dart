
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xml_fotos/data/repository/course_db.dart';
import 'package:xml_fotos/presentation/providers/course/repository.dart';

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

  Future<void> removeCourse(Course c) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repo.eliminarCursDB(c);
      return _fetchIds();
    });
  }
}

final coursesIdsProvider = AsyncNotifierProvider< CoursesIdsNotifier, List<int>>((){
  return CoursesIdsNotifier();
});