// dao/person_dao.dart

import 'package:floor/floor.dart';

import '../../models/professor.dart';

@dao
abstract class ProfessorDao {

  @Query('SELECT COUNT(*) FROM professors')
  Future<int?> countProfessors();

  @Query('SELECT * FROM professors')
  Future<List<Professor>> findAllProfessors();

  @Query('SELECT nom FROM professors')
  Stream<List<String>> findAllProfessorsNom();

  //@Query('SELECT * FROM Professor WHERE dni = :dni')
  //Stream<Professor?> findProfessorByDni(int dni);

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
}