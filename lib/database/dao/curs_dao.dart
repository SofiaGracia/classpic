import 'package:floor/floor.dart';

import '../../models/curs.dart';

@dao
abstract class CursDao {

  @Query('SELECT * FROM cursos')
  Future<List<Curs>> findAllCursos();

  @Query('SELECT nom FROM cursos')
  Stream<List<String>> findAllCursosNom();

  @Insert(onConflict: OnConflictStrategy.ignore)
  Future<int> insertCurs(Curs curs);

  @insert
  Future<void> insertCursos(List<Curs> cursos);

  @delete
  Future<void> deleteCurs(Curs curs);

  @delete
  Future<void> deleteCursos(List<Curs> cursos);

  @Query('DELETE FROM cursos')
  Future<void> buidarCursos();

  @update
  Future<void> updateCurs(Curs curs);
}