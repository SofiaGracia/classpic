import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repository/curs_db.dart';
import '../../domain/entities/curs.dart';
import 'cursos_notifier.dart';

final cursWidgetNotifierProvider = AsyncNotifierProvider.autoDispose
    .family<CursWidgetNotifier, Curs, int>(CursWidgetNotifier.new);

class CursWidgetNotifier extends AutoDisposeFamilyAsyncNotifier<Curs, int> {
  late final int id;

  Future<RepositoryCursDB> get _repo async =>
      await ref.watch(repositoryCursDBProvider.future);

  @override
  FutureOr<Curs> build(int arg) async {
    id = arg;
    final repo = await _repo;
    final curs = await repo.carregaCursDB(id);
    return curs!;
  }

  void actualitzaNom(String nouNom) {

    final curs = state.value as Curs;
    final actualitzat = curs.copyWith(
      id: curs.id,
      nom: nouNom
    );

    state = AsyncData(actualitzat);
    // també pots fer la persistència aquí
    ref.read(cursosNotifierProvider.notifier).actualitza(actualitzat);
  }
}
