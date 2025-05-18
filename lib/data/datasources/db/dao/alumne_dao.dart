// dao/person_dao.dart

import 'package:floor/floor.dart';

import '../../../../domain/entities/alumne.dart';

/// DAO per gestionar operacions amb la taula d’alumnes.
/// Inclou insercions, actualitzacions, eliminacions i consultes.
@dao
abstract class AlumneDao {

  @Query('SELECT COUNT(*) FROM alumnes')
  Future<int?> countAlumnes();

  @Query('SELECT * FROM alumnes')
  Future<List<Alumne>> findAllAlumnes();

  @Query('SELECT nom FROM alumnes')
  Stream<List<String>> findAllAlumnesNom();

  //@Query('SELECT * FROM Alumne WHERE nia = :nia')
  //Stream<Alumne?> findAlumneByNia(int id);

  @Query('SELECT * FROM alumnes WHERE id = :id')
  Future<Alumne?> findAlumneById(int id);

  @Query('SELECT * FROM alumnes WHERE cursId = :cursId')
  Future<List<Alumne>> obtenirAlumnesDelCurs(int cursId);

  @insert
  Future<void> insertAlumne(Alumne alumne);

  //@Insert(onConflict: OnConflictStrategy.ignore)
  @insert
  Future<void> insertAlumnes(List<Alumne> alumnes);

  @delete
  Future<void> deleteAlumne(Alumne alumne);

  @delete
  Future<void> deleteAlumnes(List<Alumne> alumnes);

  @update
  Future<void> updateAlumne(Alumne alumne);

  @update
  Future<void> updateAlumnes(List<Alumne> alumnes);
}