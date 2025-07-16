import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:xml_fotos/data/repository/course_db.dart';
import 'package:xml_fotos/presentation/providers/db/database.dart';

import '../../domain/entities/course.dart';

part 'cursos_notifier.g.dart';


final courseRepositoryProvider = Provider<CourseRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return CourseRepository(db.courseDao);
});

@riverpod
class CursosNotifier extends _$CursosNotifier {

  Future<CourseRepository> get _repo async => await ref.watch(courseRepositoryProvider);

  @override
  Future<List<Course>> build() async {
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

  Future<List<Course>> getCursosSenseModificarState() async {
    final repo = await _repo;
    return repo.carregarCursosDB();
  }

  Future<Course?> getCursSenseModificarState(int cursId) async {
    final repo = await _repo;
    return repo.carregaCursDB(cursId);
  }

  Future<Course?> getCursPerNom(String nom) async {
    final repo = await _repo;
    return repo.findCursNom(nom);
  }

  Future<bool> checkCurs(Course curs) async {
    final repo = await _repo;
    final actuals = await repo.carregarCursosDB();
    final nomNormalitzat = curs.name.trim().toLowerCase();

    return actuals.any((c) => c.name.trim().toLowerCase() == nomNormalitzat);
  }

  //Inserir nou curs
  Future<void> inserirCurs(Course curs) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      if (await checkCurs(curs)) {
        throw Exception('Ja existeix un curs amb el nom "${curs.name}".');
      }
      final repo = await _repo;
      final actuals = await repo.carregarCursosDB();
      final nouCurs = await repo.insertarCursDB(curs);
      return [...actuals, nouCurs];
    });
  }

  Future<void> inserirCursos(List<Course> cursos) async {
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

  Future<void> eliminarCurs(Course curs) async {

    try{
      final repo = await _repo;
      await repo.eliminarCursDB(curs);
      final actualitzats = await repo.carregarCursosDB();
      state = AsyncData(actualitzats);
    }catch (e, st){
      state = AsyncError(e, st);
    }
  }

  Future<void> eliminarCursos(List<Course> cursos) async {

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
      state = AsyncData(<Course>[]);   // Reflecteix-ho a l’estat
    } catch (e, st) {
      state = AsyncError(e, st);     // Gestiona errors
    }
  }

  Future<Course?> actualitza(Course cursActualitzat) async {
    try {
      if (await checkCurs(cursActualitzat)) {
        throw Exception('Ja existeix un curs amb el nom "${cursActualitzat.name}".');
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