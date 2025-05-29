
import 'package:flutter/cupertino.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:xml_fotos/data/datasources/db/database_service.dart';
import 'package:xml_fotos/presentation/providers/repository.dart';

import '../../data/datasources/db/dao/alumne_dao.dart';
import '../../domain/entities/alumne.dart';
import '../../data/repository/alumne_db.dart';
import 'alu_widget.dart';

part 'alumne_notifier.g.dart';

// Primer, canviem el provider de alumnes a un `FutureProvider.family`
// Així podrem passar el cursId i obtenir només els alumnes d'aquest curs.

@riverpod
Future<List<Alumne>> alumnesPerCursFiltrat(AlumnesPerCursFiltratRef ref, int? cursId) async {
  final asyncValue = ref.watch(alumnesNotifierProvider);

  return asyncValue.when(
    data: (alumnes) {
      if (cursId == null) return alumnes;
      return alumnes.where((a) => a.cursId == cursId).toList();
    },
    loading: () => [],
    error: (err, stack) => throw err,
  );
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
  }

  Future<void>  inserirAlumne(Alumne alumne) async {

    try {
      final repo = await _repo;

      final idNou = await repo.insertarAlumneDB(alumne); // ara tens l’id
      final alumneComplet = alumne.copyWith(id: idNou);

      // Opcionalment actualitza l'estat global o el individual
      final actualitzats = await repo.carregaAlumnesDB();
      state = AsyncData(actualitzats);

      // Refresca el notifier individual
      //ref.invalidate(alumneWidgetNotifierProvider(idNou));

      // Espera a que el nou notifier es construïsca correctament
      //await ref.read(alumneWidgetNotifierProvider(idNou).future);

    } catch (e, st) {
      state = AsyncError(e, st);
    }
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

  Future<List<Alumne>> getAlumnesSenseModificarState() async {
    final repo = await _repo;
    return repo.carregaAlumnesDB();
  }

  Future<List<Alumne>> getAlumnesPerCurs(int id) async {
    final repo = await _repo;
    return repo.carregaAlumnesPerCursDB(id);
  }
  
  Future<void> actualitza(Alumne usuariActualitzat) async {
    try {
      final actuals = state.requireValue;

      state = const AsyncLoading();

      final repo = await _repo;
      await repo.editarAlumneDB(usuariActualitzat);

      final actualitzats = actuals.map((alumne) {
        return alumne.id == usuariActualitzat.id ? usuariActualitzat : alumne;
      }).toList();

      state = AsyncValue.data(actualitzats);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<bool> existeixNia(String codi) async {
    final repo = await _repo;
    return await repo.carregaAlumneDBbyNia(codi) != null;
  }
}
