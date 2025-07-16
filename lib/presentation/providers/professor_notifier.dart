
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:xml_fotos/presentation/providers/teacher/repository.dart';

import '../../domain/entities/teacher.dart';
import '../../data/repository/teacher.dart';

part 'professor_notifier.g.dart';

@riverpod
class ProfessorNotifier extends _$ProfessorNotifier {

  TeacherRepository get _repo =>
      ref.watch(teacherRepositoryProvider);

  @override
  Future<List<Teacher>> build() async {
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

  Future<List<Teacher>> getProfessorsSenseModificarState() async {
    final repo = _repo;
    return repo.carregaProfessorsDB();
  }

  Future<void> inserirProfessor(Teacher professor) async {

    try{
      final repo = await _repo;
      await repo.insertTeacher(professor);

      final actualitzats = await repo.carregaProfessorsDB();
      state = AsyncData(actualitzats);

    } catch (e, st){
      state = AsyncError(e, st);
    }
  }

  Future<void> inserirProfessors(List<Teacher> professors) async {
    try{
      final repo = await _repo;
      await repo.insertarProfessorsDB(professors);

      final actualitzats = await repo.carregaProfessorsDB();
      state = AsyncData(actualitzats);

    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> eliminarProfessor(Teacher professor) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = await _repo;
      await repo.deleteTeacher(professor);
      final actuals = state.requireValue;
      return actuals.where((e) => e != professor).toList();
    });
  }

  Future<void> eliminarProfessors(List<Teacher> professors) async {
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
  Future<void> actualitza(Teacher usuariActualitzat) async {
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