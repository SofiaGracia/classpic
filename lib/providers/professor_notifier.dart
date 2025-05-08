
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:xml_fotos/repository/database.dart';

import '../database/dao/professor_dao.dart';
import '../models/professor.dart';
import '../repository/professor_db.dart';

part 'professor_notifier.g.dart';

final professorDaoProvider = FutureProvider<ProfessorDao>((ref) async {
  final dbService = DatabaseService();
  await dbService.connectaDB();
  return dbService.professorDao;
});

final repositoryProfessorDBProvider = FutureProvider<RepositoryProfessorDB>((ref) async {
  final dao = await ref.watch(professorDaoProvider.future);
  return RepositoryProfessorDB(professorDao: dao);
});

/*@riverpod
Future<List<Professor>> professorLlista(ProfessorLlista ref, int algo) async {
  final repo = await ref.watch(repositoryProfessorDBProvider.future);
  final professors = await repo.carregaProfessorsDB();
  return professors;
}*/

@riverpod
class ProfessorNotifier extends _$ProfessorNotifier {

  Future<RepositoryProfessorDB> get _repo async =>
      await ref.watch(repositoryProfessorDBProvider.future);

  @override
  Future<List<Professor>> build() async {
    final repo = await _repo;
    return repo.carregaProfessorsDB();
  }

  Future<void> carregarProfessors() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = await _repo;
      return repo.carregaProfessorsDB();
    });
  }

  Future<void> inserirProfessor(Professor professor) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = await _repo;
      await repo.insertarProfessorDB(professor);
      final actuals = state.requireValue;
      return [...actuals, professor];
    });
  }

  Future<void> inserirProfessors(List<Professor> professors) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = await _repo;
      await repo.insertarProfessorsDB(professors);
      final actuals = state.requireValue;
      return [...actuals, ...professors];
    });
  }

  Future<void> eliminarProfessor(Professor professor) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = await _repo;
      await repo.eliminarProfessorDB(professor);
      final actuals = state.requireValue;
      return actuals.where((e) => e != professor).toList();
    });
  }

  Future<void> eliminarProfessors(List<Professor> professors) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = await _repo;

      // Elimina de la base de dades
      await repo.eliminarProfessorsDB(professors);

      // Actualitza l'estat traient-los del llistat actual
      final actuals = state.requireValue;
      final dniAEliminar = professors.map((p) => p.dni).toSet();

      return actuals.where((e) => !dniAEliminar.contains(e.dni)).toList();
    });
  }

  Future<void> editarProfessor(Professor professor) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = await _repo;
      await repo.editarProfessorDB(professor);
      final actuals = state.requireValue;
      return actuals.map((e) => e.dni == professor.dni ? professor : e).toList();
    });
  }
}