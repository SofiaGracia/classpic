
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:xml_fotos/repository/curs_db.dart';
import 'package:xml_fotos/repository/database.dart';

import '../database/dao/curs_dao.dart';
import '../models/curs.dart';

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
    return repo.carregarCursDB();
  }

  Future<void> carregarCursos() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = await _repo;
      return repo.carregarCursDB();
    });
  }

  //Inserir nou curs
  Future<void> inserirCurs(Curs curs) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = await _repo;
      final nouCurs = await repo.insertarCursDB(curs);
      final actuals = state.requireValue;
      return [...actuals, nouCurs];
    });
  }

  //Gastar açò per a inserir cursos en primera instància?
  Future<void> inserirCursos(List<Curs> cursos) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = await _repo;
      await repo.inserirCursosDB(cursos);
      final actuals = state.requireValue; // Obtenim els alumnes actuals
      return [...actuals, ...cursos]; // Retornem els alumnes nous, afegint-los a l'estat actual
    });
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

  Future<void> editarCurs(Curs curs) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = await _repo;
      await repo.editarCursDB(curs);
      final actuals = state.requireValue;
      return actuals.map((e) => e.id == curs.id ? curs : e).toList();
    });
  }
}