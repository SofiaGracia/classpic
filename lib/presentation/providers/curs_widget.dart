import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/services/storage_service.dart';
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

  Future<void> actualitzaNom(String nouNom) async {
    try {

      //Ací també s'actualitza el nom del grup en els alumnes d'eixe grup.
      //pq canviem el nom però no l'id del curs
      final curs = state.value as Curs;
      final actualitzat = curs.copyWith(id: curs.id, nom: nouNom);


      final cursActualitzat = await ref.read(cursosNotifierProvider.notifier)
          .actualitza(actualitzat);

      if (cursActualitzat == null) {
        throw Exception('No s\'ha pogut actualitzar el nom del curs.');
      }

      //També ho podries fer en el provider però bueno...
      //final repoStorage = StorageService();
      //repoStorage.renombraCarpetaCurs(curs.nom, nouNom);

      state = AsyncData(cursActualitzat);
    } catch (e, st) {
      rethrow; // re-llença perquè l’UI també el pugui gestionar
    }
  }
}
