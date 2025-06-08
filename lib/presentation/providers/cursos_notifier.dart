import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:xml_fotos/application/services/storage_service.dart';
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
class CursosNotifier extends _$CursosNotifier {

  Future<RepositoryCursDB> get _repo async => await ref.watch(repositoryCursDBProvider.future);

  @override
  Future<List<Curs>> build() async {
    final repo = await _repo;
    return repo.carregarCursosDB();//Incicialitzem l'estat
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

  Future<Curs?> getCursSenseModificarState(int cursId) async {
    final repo = await _repo;
    return repo.carregaCursDB(cursId);
  }

  Future<Curs?> getCursPerNom(String nom) async {
    final repo = await _repo;
    return repo.findCursNom(nom);
  }

  Future<bool> checkCurs(Curs curs) async {
    final repo = await _repo;
    final actuals = await repo.carregarCursosDB();
    final nomNormalitzat = curs.nom.trim().toLowerCase();

    return actuals.any((c) => c.nom.trim().toLowerCase() == nomNormalitzat);
  }

  //Inserir nou curs
  Future<void> inserirCurs(Curs curs) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      if (await checkCurs(curs)) {
        throw Exception('Ja existeix un curs amb el nom "${curs.nom}".');
      }
      final repo = await _repo;
      final actuals = await repo.carregarCursosDB();
      final nouCurs = await repo.insertarCursDB(curs);
      return [...actuals, nouCurs];
    });
  }

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

    try{
      final repo = await _repo;
      await repo.eliminarCursDB(curs);
      final actualitzats = await repo.carregarCursosDB();
      state = AsyncData(actualitzats);
    }catch (e, st){
      state = AsyncError(e, st);
    }
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

  Future<Curs?> actualitza(Curs cursActualitzat) async {
    try {
      if (await checkCurs(cursActualitzat)) {
        throw Exception('Ja existeix un curs amb el nom "${cursActualitzat.nom}".');
      }

      final actuals = await getCursosSenseModificarState();

      state = const AsyncLoading();
      final repo = await _repo;
      await repo.editarCursDB(cursActualitzat);

      final actualitzats = actuals.map((curs) {
        return curs.id == cursActualitzat.id ? cursActualitzat : curs;
      }).toList();

      state = AsyncValue.data(actualitzats);

      return cursActualitzat;
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}