import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:classpic/data/repository/teacher.dart';
import 'package:classpic/presentation/providers/teacher/repository.dart';

import '../../../domain/entities/teacher.dart';

class AsyncTeacherIdsNotifier extends AsyncNotifier<List<int>> {
  TeacherRepository get _repo => ref.watch(teacherRepositoryProvider);

  Future<List<int>> _fetchIds() async {
    return await _repo.getAllIdsTeacher();
  }

  @override
  Future<List<int>> build() async {
    return _fetchIds();
  }

  Future<void> addTeacher(Teacher t) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repo.insertTeacher(t);
      return _fetchIds();
    });
  }

  Future<void> addTeachers(List<Teacher> t) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repo.insertarProfessorsDB(t);
      return _fetchIds();
    });
  }

  Future<void> removeTeacher(Teacher t) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repo.deleteTeacher(t);
      return _fetchIds();
    });
  }

  Future<void> removeTeachers(List<Teacher> t) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repo.eliminarProfessorsDB(t);
      return _fetchIds();
    });
  }
}

final asyncTeacherIdsProvider =
AsyncNotifierProvider<AsyncTeacherIdsNotifier, List<int>>(() {
  return AsyncTeacherIdsNotifier();
});