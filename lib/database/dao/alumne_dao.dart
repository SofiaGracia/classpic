// dao/person_dao.dart

import 'package:floor/floor.dart';

import '../../models/alumne.dart';

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

  @insert
  Future<void> insertAlumne(Alumne alumne);

  //@Insert(onConflict: OnConflictStrategy.ignore)
  @insert
  Future<void> insertAlumnes(List<Alumne> alumnes);
}