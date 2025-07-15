import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:xml_fotos/presentation/providers/student/repository.dart';

import '../../data/repository/student.dart';
import '../../domain/entities/student.dart';
import 'alumne_notifier.dart';

class AluWidgetNotifier extends AutoDisposeFamilyAsyncNotifier<Student, int> {
  late final int id;

  StudentRepository get _repo => ref.watch(studentRepositoryProvider);

  @override
  FutureOr<Student> build(int arg) async {
    id = arg;
    final repo = await _repo;
    final alu = await repo.carregaAlumneDB(id);
    return alu!;
  }

  Future<void> actualitza(Student nou) async {
    var cridarGlobal = false;

    final alu = state.value as Student;
    final actualitzat = alu.copyWith(
        id: alu.id,
        nia: nou.nia,
        name: nou.name,
        s1: nou.s1,
        s2: nou.s2,
        photoPathHash: nou.photoPathHash,
        hasFoto: nou.hasFoto);

    //Si se li ha canviat el path de la foto
    // (abans no tenia i ara sí també hem de cridar al mètode de la llista global)
    // Hem de comparar-ho per fotoPathHash

    //Comparem el cursId nou i el vell per si canvia
    //si canvia és que ha canviat de grup i hem de cridar al mètode actualitza de la llista global

    if (alu.courseId != nou.courseId) {
      cridarGlobal = true;
      actualitzat.courseId = nou.courseId;
      actualitzat.group = nou.group;
    }

    if (alu.photoPathHash != nou.photoPathHash) {
      cridarGlobal = true;
    }

    if (cridarGlobal) {
      ref.read(alumnesNotifierProvider.notifier).actualitza(actualitzat);
    } else {
      final repo = await _repo;
      final alumneEditat = await repo.editarAlumneDB(actualitzat);
    }
    state = AsyncData(actualitzat);
  }
}

final alumneWidgetNotifierProvider = AsyncNotifierProvider.autoDispose
    .family<AluWidgetNotifier, Student, int>(AluWidgetNotifier.new);
