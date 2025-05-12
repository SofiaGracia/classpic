
import 'package:flutter/cupertino.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:xml_fotos/repository/database.dart';

import '../database/dao/alumne_dao.dart';
import '../models/alumne.dart';
import '../repository/alumne_db.dart';

part 'alumne_notifier.g.dart';

final alumneDaoProvider = FutureProvider<AlumneDao>((ref) async {
  final dbService = DatabaseService();
  await dbService.connectaDB();
  return dbService.alumneDao;
});

final repositoryAlumneDBProvider = FutureProvider<RepositoryAlumneDB>((ref) async {
  final dao = await ref.watch(alumneDaoProvider.future);
  return RepositoryAlumneDB(alumneDao: dao);
});

// Primer, canviem el provider de alumnes a un `FutureProvider.family`
// Així podrem passar el cursId i obtenir només els alumnes d'aquest curs.

@riverpod
Future<List<Alumne>> alumnesPerCursFiltrat(AlumnesPerCursFiltratRef ref, int? cursId) async {
  final asyncAlumnes = await ref.watch(alumnesNotifierProvider.future);
  if (cursId == null) return asyncAlumnes;
  return asyncAlumnes.where((a) => a.cursId == cursId).toList();
}

@riverpod
Future<int> alumnesTotal(AlumnesTotalRef ref) async {
  final alumnes = await ref.watch(alumnesNotifierProvider.future);
  return alumnes.length;
}

@riverpod
Future<List<Alumne>> alumnesTots(AlumnesTotsRef ref) async {
  final alumnes = await ref.watch(alumnesNotifierProvider.future);
  return alumnes;
}

@riverpod
class AlumnesNotifier extends _$AlumnesNotifier {

  Future<RepositoryAlumneDB> get _repo async =>
      await ref.watch(repositoryAlumneDBProvider.future);

  @override
  Future<List<Alumne>> build() async {
    final repo = await _repo;
    return repo.carregaAlumnesDB();
  }

  Future<void> carregarAlumnes() async {
    /*state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = await _repo;
      return repo.carregaAlumnesDB();
    });*/

    try{
      final repo = await _repo;
      final actualitzats = await repo.carregaAlumnesDB();

      state = AsyncData(actualitzats);

    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  //Te falta inserirAlumnes
  Future<void> inserirAlumnes(List<Alumne> alumnes) async {

    try{
      final repo = await _repo;
      await repo.inserirAlumnesDB(alumnes);

      final actualitzats = await repo.carregaAlumnesDB();
      state = AsyncData(actualitzats);

    } catch (e, st) {
      state = AsyncError(e, st);
    }

    /*state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = await _repo;
      await repo.inserirAlumnesDB(alumnes);
      final actuals = state.requireValue; // Obtenim els alumnes actuals
      return [...actuals, ...alumnes]; // Retornem els alumnes nous, afegint-los a l'estat actual
    });*/
  }

  Future<void> inserirAlumne(Alumne alumne) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = await _repo;
      await repo.insertarAlumneDB(alumne);
      final actuals = state.requireValue;
      return [...actuals, alumne];
    });
  }

  Future<void> eliminarAlumne(Alumne alumne) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = await _repo;
      await repo.eliminarAlumneDB(alumne);
      final actuals = state.requireValue;
      return actuals.where((e) => e != alumne).toList();
    });
  }

  Future<void> eliminarAlumnes(List<Alumne> alumnes) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = await _repo;
      await repo.eliminarAlumnesDB(alumnes);
      final actuals = state.requireValue; // Obtenim els alumnes actuals
      final niaAEliminar = alumnes.map((a) => a.nia).toSet();

      return actuals.where((a) => !niaAEliminar.contains(a.nia)).toList();
    });
  }

  Future<void> editarAlumne(Alumne alumne) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = await _repo;
      await repo.editarAlumneDB(alumne);
      final actuals = state.requireValue;
      final nous = actuals.map((e) => e.nia == alumne.nia ? alumne : e).toList();
      return nous;
    });
  }

  Future<void> editarAlumnes(List<Alumne> alumnes) async {
    try {
      final repo = await _repo;

      await repo.editarAlumnesDB(alumnes);

      final actuals = state.requireValue;

      final idsEditats = alumnes.map((a) => a.id).toSet();

      final List<Alumne> actualitzats = [];

      for (final a in actuals) {
        if (idsEditats.contains(a.id)) {
          final alumneEditat = alumnes.firstWhere((editat) => editat.id == a.id);
          actualitzats.add(alumneEditat);
        } else {
          actualitzats.add(a);
        }
      }
      state = AsyncValue.data(actualitzats);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
