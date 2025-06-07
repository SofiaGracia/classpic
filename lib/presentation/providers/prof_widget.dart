// usuari_notifier.dart
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:xml_fotos/presentation/providers/professor_notifier.dart';
import 'package:xml_fotos/presentation/providers/repository.dart';

import '../../data/repository/professor_db.dart';
import '../../domain/entities/professor.dart';

// usuari_notifier.dart
class ProfWidgetNotifier extends AutoDisposeFamilyAsyncNotifier<Professor, int> {
  late final int id;

  Future<RepositoryProfessorDB> get _repo async =>
      await ref.watch(repositoryProfessorDBProvider.future);

  @override
  FutureOr<Professor> build(int arg) async {
    id = arg;
    final repo = await _repo;
    final professor = await repo.carregaProfessorDB(id);
    return professor!;
  }

  Future<void> actualitza(Professor nou) async {

    final prof = state.value as Professor;
     final actualitzat = prof.copyWith(
      id: prof.id,
      dni: nou.dni,
      nom: nou.nom,
      c1: nou.c1,
      c2: nou.c2,
      fotoPath: nou.fotoPath,
       fotoPathHash: nou.fotoPathHash,
    );

    state = AsyncData(actualitzat);

    final repo = await _repo;
    await repo.editarProfessorDB(actualitzat);

  }
}

final professorWidgetNotifierProvider = AsyncNotifierProvider.autoDispose
    .family<ProfWidgetNotifier, Professor, int>(ProfWidgetNotifier.new);
