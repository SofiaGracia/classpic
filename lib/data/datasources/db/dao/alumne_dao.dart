// dao/person_dao.dart

import 'package:floor/floor.dart';

import '../../../../domain/entities/student.dart';

/// DAO per gestionar operacions amb la taula d’alumnes.
/// Inclou insercions, actualitzacions, eliminacions i consultes.
@dao
abstract class AlumneDao {

  @Query('SELECT COUNT(*) FROM alumnes')
  Future<int?> countAlumnes();

  @Query('SELECT * FROM alumnes')
  Future<List<Student>> findAllAlumnes();

  @Query('SELECT nom FROM alumnes')
  Stream<List<String>> findAllAlumnesNom();

  @Query('SELECT * FROM alumnes WHERE fotoFilename IS NOT NULL')
  Future<List<Student>> findAlumnesWithFoto();

  //@Query('SELECT * FROM Alumne WHERE nia = :nia')
  //Stream<Alumne?> findAlumneByNia(int id);

  @Query('SELECT * FROM alumnes WHERE id = :id')
  Future<Student?> findAlumneById(int id);
  
  //STREAM D'IDS
  //@Query('SELECT id FROM alumnes')

  @Query('SELECT * FROM alumnes WHERE nia = :nia')
  Future<Student?> findAlumneByNia(String nia);

  @Query('SELECT * FROM alumnes WHERE cursId = :cursId')
  Future<List<Student>> obtenirAlumnesDelCurs(int cursId);

  @insert
  Future<int> insertAlumne(Student alumne);

  //@Insert(onConflict: OnConflictStrategy.ignore)
  @insert
  Future<void> insertAlumnes(List<Student> alumnes);

  @delete
  Future<void> deleteAlumne(Student alumne);

  @delete
  Future<void> deleteAlumnes(List<Student> alumnes);

  @update
  Future<void> updateAlumne(Student alumne);

  @update
  Future<void> updateAlumnes(List<Student> alumnes);
}