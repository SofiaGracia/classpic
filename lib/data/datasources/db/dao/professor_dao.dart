// dao/person_dao.dart

import 'package:floor/floor.dart';

import '../../../../domain/entities/professor.dart';

//DAO per gestionar operacions amb la taula de professors.
// Inclou insercions, actualitzacions, eliminacions i consultes.
@dao
abstract class ProfessorDao {

  @Query('SELECT COUNT(*) FROM professors')
  Future<int?> countProfessors();

  @Query('SELECT * FROM professors')
  Future<List<Professor>> findAllProfessors();

  @Query('SELECT nom FROM professors')
  Stream<List<String>> findAllProfessorsNom();

  @Query('SELECT * FROM professors WHERE fotoFilename IS NOT NULL')
  Future<List<Professor>> findProfessorsWithFoto();

  @Query('SELECT * FROM professors WHERE id = :id')
  Future<Professor?> findProfessorById(int id);

  //STREAM DE PROFESSORS
  @Query('SELECT id FROM professors')
  Stream<List<int>> observeIdsProfessors();

  @Query('SELECT * FROM professors WHERE dni = :dni')
  Future<Professor?> findProfessorByDni(String dni);

  @insert
  Future<void> insertProfessor(Professor professor);

  //@Insert(onConflict: OnConflictStrategy.ignore)
  @insert
  Future<void> insertProfessors(List<Professor> professors);

  @delete
  Future<void> deleteProfessor(Professor professor);

  @delete
  Future<void> deleteProfessors(List<Professor> professors);

  @update
  Future<void> updateProfessor(Professor professor);

  @update
  Future<void> updateProfessors(List<Professor> professor);
}