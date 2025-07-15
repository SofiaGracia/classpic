// usuari_notifier.dart
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:xml_fotos/presentation/providers/professor_notifier.dart';
import 'package:xml_fotos/presentation/providers/teacher/repository.dart';

import '../../data/repository/teacher.dart';
import '../../domain/entities/teacher.dart';

// usuari_notifier.dart
class ProfWidgetNotifier extends AutoDisposeFamilyAsyncNotifier<Teacher, int> {
  late final int id;

  TeacherRepository get _repo => ref.watch(teacherRepositoryProvider);

  @override
  FutureOr<Teacher> build(int arg) async {
    id = arg;
    final repo = await _repo;
    final professor = await repo.carregaProfessorDB(id);
    return professor!;
  }

  Future<void> actualitza(Teacher nou) async {
    final prof = state.value as Teacher;
    final actualitzat = prof.copyWith(
        id: prof.id,
        dni: nou.dni,
        name: nou.name,
        s1: nou.s1,
        s2: nou.s2,
        photoPathHash: nou.photoPathHash,
        hasFoto: nou.hasFoto);

    if (prof.photoPathHash != nou.photoPathHash) {
      ref.read(professorNotifierProvider.notifier).actualitza(actualitzat);
    } else {
      final repo = await _repo;
      await repo.editarProfessorDB(actualitzat);
    }
    state = AsyncData(actualitzat);
  }
}

final professorWidgetNotifierProvider = AsyncNotifierProvider.autoDispose
    .family<ProfWidgetNotifier, Teacher, int>(ProfWidgetNotifier.new);
