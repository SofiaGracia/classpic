
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:xml_fotos/presentation/providers/repository.dart';

import '../../domain/entities/professor.dart';
import '../../data/repository/professor_db.dart';

part 'professor_notifier.g.dart';

@riverpod
class ProfessorNotifier extends _$ProfessorNotifier {

  RepositoryProfessorDB get _repo =>
      ref.watch(repositoryProfessorDBProvider);

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

  Future<List<Professor>> getProfessorsSenseModificarState() async {
    final repo = await _repo;
    return repo.carregaProfessorsDB();
  }

  Future<void> inserirProfessor(Professor professor) async {

    try{
      final repo = await _repo;
      await repo.insertarProfessorDB(professor);

      final actualitzats = await repo.carregaProfessorsDB();
      state = AsyncData(actualitzats);

    } catch (e, st){
      state = AsyncError(e, st);
    }
  }

  Future<void> inserirProfessors(List<Professor> professors) async {
    try{
      final repo = await _repo;
      await repo.insertarProfessorsDB(professors);

      final actualitzats = await repo.carregaProfessorsDB();
      state = AsyncData(actualitzats);

    } catch (e, st) {
      state = AsyncError(e, st);
    }
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

  //Exemple d’actualització de la llista global amb canvi d’un usuari:
  // Aquest mètode l’has d’executar des del UsuariNotifier quan fas un canvi local.
  Future<void> actualitza(Professor usuariActualitzat) async {
    try {
      final actuals = state.requireValue;

      state = const AsyncLoading();

      final repo = await _repo;
      await repo.editarProfessorDB(usuariActualitzat);

      final actualitzats = actuals.map((professor) {
        return professor.id == usuariActualitzat.id ? usuariActualitzat : professor;
      }).toList();

      state = AsyncValue.data(actualitzats);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<bool> existeixDni(String codi) async {
    final repo = await _repo;
    return await repo.carregaProfessorDBbyDni(codi) != null;
  }
}