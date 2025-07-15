// dao/person_dao.dart

import 'package:floor/floor.dart';

import '../../../../domain/entities/teacher.dart';

//DAO per gestionar operacions amb la taula de professors.
// Inclou insercions, actualitzacions, eliminacions i consultes.
@dao
abstract class TeacherDao {

  @Query('SELECT COUNT(*) FROM professors')
  Future<int?> countProfessors();

  @Query('SELECT * FROM professors')
  Future<List<Teacher>> findAllProfessors();

  @Query('SELECT nom FROM professors')
  Stream<List<String>> findAllProfessorsNom();

  @Query('SELECT * FROM professors WHERE fotoFilename IS NOT NULL')
  Future<List<Teacher>> findProfessorsWithFoto();

  @Query('SELECT * FROM professors WHERE id = :id')
  Future<Teacher?> findProfessorById(int id);

  //STREAM DE IDS DE PROFESSORS
  @Query('SELECT dni FROM professors')
  Stream<List<String>> observeIdsProfessors();

  @Query('SELECT * FROM professors WHERE dni = :dni')
  Future<Teacher?> findProfessorByDni(String dni);

  @insert
  Future<void> insertProfessor(Teacher professor);

  //@Insert(onConflict: OnConflictStrategy.ignore)
  @insert
  Future<void> insertProfessors(List<Teacher> professors);

  @delete
  Future<void> deleteProfessor(Teacher professor);

  @delete
  Future<void> deleteProfessors(List<Teacher> professors);

  @update
  Future<void> updateProfessor(Teacher professor);

  @update
  Future<void> updateProfessors(List<Teacher> professor);
}