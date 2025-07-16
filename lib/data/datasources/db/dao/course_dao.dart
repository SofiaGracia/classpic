import 'package:floor/floor.dart';

import '../../../../domain/entities/course.dart';

//DAO per gestionar operacions amb la taula de curs.
// Inclou insercions, actualitzacions, eliminacions i consultes.
@dao
abstract class CourseDao {

  @Query('SELECT * FROM course')
  Future<List<Course>> findAllCourses();

  @Query('SELECT nom FROM course')
  Stream<List<String>> findAllCoursesName();

  @Query('SELECT * FROM course WHERE id = :id')
  Future<Course?> findCourseById(int id);

  @Query('SELECT id FROM course WHERE id IS NOT NULL')
  Future<List<int>> getAllCoursesIds();

  @Query('SELECT * FROM course WHERE name = :name')
  Future<Course?> findCourseByName(String name);

  @Insert(onConflict: OnConflictStrategy.ignore)
  Future<int> insertCourse(Course curs);

  @insert
  Future<void> insertCourses(List<Course> courses);

  @delete
  Future<void> deleteCourse(Course curs);

  @delete
  Future<void> deleteCourses(List<Course> courses);

  @Query('DELETE FROM course')
  Future<void> deleteCoursesAndItsContent();

  @update
  Future<void> updateCurs(Course curs);
}