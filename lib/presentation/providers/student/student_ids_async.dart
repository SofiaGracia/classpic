import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xml_fotos/data/repository/student.dart';
import 'package:xml_fotos/presentation/providers/student/repository.dart';

import '../../../domain/entities/student.dart';

class AsyncStudentsIdsNotifier extends FamilyAsyncNotifier<List<int>, int> {
  StudentRepository get _repo => ref.watch(studentRepositoryProvider);

  Future<List<int>> _fetchIds(int courseId) async {
    return await _repo.getStudentsIdsByCourse(courseId);
  }

  @override
  FutureOr<List<int>> build(int courseId) async {
    return await _fetchIds(courseId);
  }

  Future<void> addStudent(Student s) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repo.insertStudent(s);
      return _fetchIds(s.courseId!);
    });
  }

  Future<void> removeStudent(Student s) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repo.deleteStudent(s);
      return _fetchIds(s.courseId!);
    });
  }
}

final studentIdsProvider =
    AsyncNotifierProvider.family<AsyncStudentsIdsNotifier, List<int>, int>(
        AsyncStudentsIdsNotifier.new);
