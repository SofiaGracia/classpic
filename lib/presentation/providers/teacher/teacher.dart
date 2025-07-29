import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:classpic/presentation/providers/teacher/repository.dart';

import '../../../data/repository/teacher.dart';
import '../../../domain/entities/teacher.dart';

class TeacherWidgetNotifier extends AutoDisposeFamilyAsyncNotifier<Teacher, int> {

  TeacherRepository get _repo => ref.watch(teacherRepositoryProvider);

  @override
  FutureOr<Teacher> build(int id) async {
    final professor = await _repo.carregaProfessorDB(id);
    return professor!;
  }

  Future<void> updateUser(Teacher t) async {
    final teacher = state.value as Teacher;
    final updated = teacher.copyWith(
        id: teacher.id,
        dni: t.dni,
        name: t.name,
        s1: t.s1,
        s2: t.s2,
        photoPathHash: t.photoPathHash,
        hasFoto: t.hasFoto);

    /*if (teacher.photoPathHash != t.photoPathHash) {
      ref.read(professorNotifierProvider.notifier).actualitza(updated);
    } else {
      await _repo.editarProfessorDB(updated);
    }*/
    await _repo.editarProfessorDB(updated);
    state = AsyncData(updated);
  }
}

final teacherWidgetNotifierProvider = AsyncNotifierProvider.autoDispose
    .family<TeacherWidgetNotifier, Teacher, int>(TeacherWidgetNotifier.new);
