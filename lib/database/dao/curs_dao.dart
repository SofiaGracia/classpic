import 'package:floor/floor.dart';

import '../../models/curs.dart';

@dao
abstract class CursDao {

  @Query('SELECT * FROM cursos')
  Future<List<Curs>> findAllCursos();

  @Query('SELECT nom FROM cursos')
  Stream<List<String>> findAllCursosNom();

  @insert
  Future<int> insertCurs(Curs curs);

  @insert
  Future<void> insertCursos(List<Curs> cursos);

  @delete
  Future<void> deleteCurs(Curs curs);

  @update
  Future<void> updateCurs(Curs curs);
}