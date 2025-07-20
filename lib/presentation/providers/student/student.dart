import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:xml_fotos/presentation/providers/student/repository.dart';
import 'package:xml_fotos/presentation/providers/student/student_ids_async.dart';

import '../../../data/repository/student.dart';
import '../../../domain/entities/student.dart';

class StudentWidgetNotifier extends AutoDisposeFamilyAsyncNotifier<Student, int> {

  StudentRepository get _repo => ref.watch(studentRepositoryProvider);

  @override
  FutureOr<Student> build(int id) async {
    final alu = await _repo.findStudentById(id);
    return alu!;
  }

  Future<void> updateUser(Student s) async {

    final current = state.value as Student;
    final updated = current.copyWith(
        id: current.id,
        nia: s.nia,
        name: s.name,
        s1: s.s1,
        s2: s.s2,
        photoPathHash: s.photoPathHash,
        hasFoto: s.hasFoto);

    final hasChangedCourse = current.courseId != s.courseId;

    if (hasChangedCourse) {

      updated.courseId = s.courseId;
      updated.group = s.group;

      await ref
          .read(studentIdsProvider(current.courseId!).notifier)
          .updateStudentCourse(updated, current);
    } else {
      await _repo.updateStudent(updated);
    }
    state = AsyncData(updated);
  }
}

final studentWidgetNotifierProvider = AsyncNotifierProvider.autoDispose
    .family<StudentWidgetNotifier, Student, int>(StudentWidgetNotifier.new);
