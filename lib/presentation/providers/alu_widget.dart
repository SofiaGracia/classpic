// usuari_notifier.dart
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:xml_fotos/presentation/providers/repository.dart';

import '../../data/repository/alumne_db.dart';
import '../../domain/entities/alumne.dart';
import 'alumne_notifier.dart';

// usuari_notifier.dart
class AluWidgetNotifier extends AutoDisposeFamilyAsyncNotifier<Alumne, int> {
  late final int id;

  Future<RepositoryAlumneDB> get _repo async =>
      await ref.watch(repositoryAlumneDBProvider.future);

  @override
  FutureOr<Alumne> build(int arg) async {
    id = arg;
    final repo = await _repo;
    final alu = await repo.carregaAlumneDB(id);
    return alu!;
  }

  Future<void> actualitza(Alumne nou) async {

    final alu = state.value as Alumne;
    final actualitzat = alu.copyWith(
      id: alu.id,
      nia: nou.nia,
      nom: nou.nom,
      c1: nou.c1,
      c2: nou.c2,
      fotoPath: nou.fotoPath,
      fotoPathHash: nou.fotoPathHash,
      grup: nou.grup
    );

    state = AsyncData(actualitzat);

    //Actualitzar a la llista global
    ref.read(alumnesNotifierProvider.notifier).actualitza(actualitzat);
  }
}

final alumneWidgetNotifierProvider = AsyncNotifierProvider.autoDispose
    .family<AluWidgetNotifier, Alumne, int>(AluWidgetNotifier.new);
