// dao/person_dao.dart

import 'package:floor/floor.dart';

import '../../../../domain/entities/student.dart';

/// DAO per gestionar operacions amb la taula d’student.
/// Inclou insercions, actualitzacions, eliminacions i consultes.
@dao
abstract class StudentDao {

  @Query('SELECT COUNT(*) FROM student')
  Future<int?> countStudents();

  @Query('SELECT * FROM student')
  Future<List<Student>> findAllStudents();

  @Query('SELECT name FROM student')
  Stream<List<String>> findAllStudentsName();

  //@Query('SELECT * FROM student WHERE fotoFilename IS NOT NULL')
  //Future<List<Student>> findStudentsWithFoto();

  //@Query('SELECT * FROM Student WHERE nia = :nia')
  //Stream<Student?> findStudentByNia(int id);

  @Query('SELECT * FROM student WHERE id = :id')
  Future<Student?> findStudentById(int id);
  
  //STREAM D'IDS
  //@Query('SELECT id FROM students')

  @Query('SELECT * FROM student WHERE nia = :nia')
  Future<Student?> findStudentByNia(String nia);

  @Query('SELECT * FROM student WHERE courseId = :courseId')
  Future<List<Student>> getStudentsByCurs(int courseId);

  @insert
  Future<int> insertStudent(Student student);

  //@Insert(onConflict: OnConflictStrategy.ignore)
  @insert
  Future<void> insertStudents(List<Student> students);

  @delete
  Future<void> deleteStudent(Student student);

  @delete
  Future<void> deleteStudents(List<Student> students);

  @update
  Future<void> updateStudent(Student student);

  @update
  Future<void> updateStudents(List<Student> students);
}