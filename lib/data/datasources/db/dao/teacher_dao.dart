
import 'package:floor/floor.dart';

import '../../../../domain/entities/teacher.dart';

@dao
abstract class TeacherDao {

  @Query('SELECT COUNT(*) FROM teacher')
  Future<int?> countTeachers();

  @Query('SELECT * FROM teacher')
  Future<List<Teacher>> findAllTeachers();

  @Query('SELECT name FROM teacher')
  Stream<List<String>> findAllTeachersName();

  //@Query('SELECT * FROM teacher WHERE fotoFilename IS NOT NULL')
  //Future<List<Teacher>> findTeachersWithPhoto();

  @Query('SELECT * FROM teacher WHERE id = :id')
  Future<Teacher?> findTeacherById(int id);

  //STREAM DE IDS DE PROFESSORS
  @Query('SELECT id FROM teacher')
  Stream<List<int>> observeIdsTeacher();

  @Query('SELECT * FROM teacher WHERE dni = :dni')
  Future<Teacher?> findTeacherByDni(String dni);

  @insert
  Future<void> insertTeacher(Teacher professor);

  //@Insert(onConflict: OnConflictStrategy.ignore)
  @insert
  Future<void> insertTeachers(List<Teacher> professors);

  @delete
  Future<void> deleteTeacher(Teacher professor);

  @delete
  Future<void> deleteTeachers(List<Teacher> professors);

  @update
  Future<void> updateTeacher(Teacher professor);

  @update
  Future<void> updateTeachers(List<Teacher> professor);
}