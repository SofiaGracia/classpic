import 'package:floor/floor.dart';

import '../../../../domain/entities/course.dart';

//DAO per gestionar operacions amb la taula de curs.
// Inclou insercions, actualitzacions, eliminacions i consultes.
@dao
abstract class CursDao {

  @Query('SELECT * FROM cursos')
  Future<List<Course>> findAllCursos();

  @Query('SELECT nom FROM cursos')
  Stream<List<String>> findAllCursosNom();

  @Query('SELECT * FROM cursos WHERE id = :id')
  Future<Course?> findCursById(int id);

  @Query('SELECT * FROM cursos WHERE nom = :nom')
  Future<Course?> findCursByNom(String nom);

  @Insert(onConflict: OnConflictStrategy.ignore)
  Future<int> insertCurs(Course curs);

  @insert
  Future<void> insertCursos(List<Course> cursos);

  @delete
  Future<void> deleteCurs(Course curs);

  @delete
  Future<void> deleteCursos(List<Course> cursos);

  @Query('DELETE FROM cursos')
  Future<void> buidarCursos();

  @update
  Future<void> updateCurs(Course curs);
}