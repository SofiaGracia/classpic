import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:xml_fotos/data/repository/curs_db.dart';
import 'package:xml_fotos/data/datasources/db/database_service.dart';

import '../../data/datasources/db/dao/curs_dao.dart';
import '../../domain/entities/curs.dart';

part 'cursos_notifier.g.dart';

final cursDaoProvider = FutureProvider<CursDao>((ref) async {
  final dbService = DatabaseService();
  await dbService.connectaDB();
  return dbService.cursDao;
});

final repositoryCursDBProvider = FutureProvider<RepositoryCursDB>((ref) async {
  final dao = await ref.watch(cursDaoProvider.future);
  return RepositoryCursDB(cursDao: dao);
});

@riverpod
Future<List<Curs>> cursTots(CursTotsRef ref) async {
  final cursos = await ref.watch(cursosNotifierProvider.future);
  return cursos;
}

@riverpod
Future<Curs> cursPerId(CursPerIdRef ref, int cursId) async {
  final cursos = await ref.watch(cursosNotifierProvider.future);
  // Filtra i retorna el curs amb el cursId especificat
  return cursos.firstWhere((curs) => curs.id == cursId);
}

@riverpod
class CursosNotifier extends _$CursosNotifier {

  Future<RepositoryCursDB> get _repo async => await ref.watch(repositoryCursDBProvider.future);

  @override
  Future<List<Curs>> build() async {
    final repo = await _repo;
    return repo.carregarCursosDB();
  }

  Future<void> carregarCursos() async {
    try{
      final repo = await _repo;
      final actualitzats = await repo.carregarCursosDB();
      state = AsyncData(actualitzats);
    }catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<List<Curs>> getCursosSenseModificarState() async {
    final repo = await _repo;
    return repo.carregarCursosDB();
  }

  //Inserir nou curs
  Future<void> inserirCurs(Curs curs) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = await _repo;
      final actuals = await repo.carregarCursosDB();
      final nomNormalitzat = curs.nom.trim().toLowerCase();

      final jaExisteix = actuals.any((c) => c.nom.trim().toLowerCase() == nomNormalitzat);
      if (jaExisteix) {
        throw Exception('Ja existeix un curs amb el nom "${curs.nom}".');
      }
      final nouCurs = await repo.insertarCursDB(curs);
      return [...actuals, nouCurs];
    });
  }

  /*Quan fas state = await AsyncValue.guard(...), dins del bloc guard(...) estàs intentant accedir a state.requireValue,
   mentre state encara no ha sigut actualitzat amb el nou valor.*/

  Future<void> inserirCursos(List<Curs> cursos) async {
    try {
      final repo = await _repo;
      await repo.inserirCursosDB(cursos);
      // Carrega real des de la base de dades per obtindre els IDs correctes
      final actualitzats = await repo.carregarCursosDB();
      state = AsyncData(actualitzats);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> eliminarCurs(Curs curs) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = await _repo;
      await repo.eliminarCursDB(curs);
      final actuals = state.requireValue;
      return actuals.where((e) => e != curs).toList();
    });
  }

  Future<void> eliminarCursos(List<Curs> cursos) async {

    //Vull fer-ho de esta manera:
    try {
      final repo = await _repo;
      await repo.eliminarCursosDB(cursos);

      final actuals = state.requireValue;
      final idAEliminar = cursos.map((c) => c.id).toSet();

      // Actualitza l'estat eliminant els cursos
      final nousCursos = actuals.where((a) => !idAEliminar.contains(a.id)).toList();
      state = AsyncValue.data(nousCursos);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> buidarCursos() async {
    try {
      final repo = await _repo;
      await repo.buidarCursosBD(); // Elimina de la BD
      state = AsyncData(<Curs>[]);   // Reflecteix-ho a l’estat
    } catch (e, st) {
      state = AsyncError(e, st);     // Gestiona errors
    }
  }

  Future<void> actualitza(Curs cursActualitzat) async {
    try{
      final actuals = state.requireValue;
      state = const AsyncLoading();
      final repo = await _repo;
      await repo.editarCursDB(cursActualitzat);
      final actualitzats = actuals.map((curs) {
        return curs.id == cursActualitzat.id ? cursActualitzat : curs;
      }).toList();

      state = AsyncValue.data(actualitzats);
    }catch (e, st){
      state = AsyncError(e, st);
    }
  }
}