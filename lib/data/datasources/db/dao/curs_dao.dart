import 'package:floor/floor.dart';

import '../../../../domain/entities/curs.dart';

//DAO per gestionar operacions amb la taula de curs.
// Inclou insercions, actualitzacions, eliminacions i consultes.
@dao
abstract class CursDao {

  @Query('SELECT * FROM cursos')
  Future<List<Curs>> findAllCursos();

  @Query('SELECT nom FROM cursos')
  Stream<List<String>> findAllCursosNom();

  @Query('SELECT * FROM cursos WHERE id = :id')
  Future<Curs?> findCursById(int id);

  @Query('SELECT * FROM cursos WHERE nom = :nom')
  Future<Curs?> findCursByNom(String nom);

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