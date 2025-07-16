import 'package:flutter/cupertino.dart';

import '../datasources/db/dao/course_dao.dart';
import '../../domain/entities/course.dart';

class CourseRepository {
  final CourseDao _dao;

  CourseRepository(this._dao);

  Future<List<Course>> carregarCursosDB() async {
    final cursos = await _dao.findAllCourses();
    return cursos;
  }

  Future<List<int>> getAllCoursesIds() async {
    return await _dao.getAllCoursesIds();
  }

  Future<Course?> carregaCursDB(int id) async {
    return await _dao.findCourseById(id);
  }

  Future<Course?> findCursNom(String nom) async {
    return await _dao.findCourseByName(nom);
  }

  Future<Course> insertarCursDB(Course curs) async {
    final id = await _dao.insertCourse(curs);
    return curs.copyWith(id: id);
  }

  Future<void> inserirCursosDB(List<Course> cursos) async {
    await _dao.insertCourses(cursos);
  }

  Future<void> imprimirCursosDB() async {
    final cursos = await _dao.findAllCourses();
    for (var c in cursos) {
      debugPrint('${c.id}: ${c.name}');
    }
  }

  Future<void> eliminarCursDB(Course curs) async {
    await _dao.deleteCourse(curs);
  }

  Future<void> eliminarCursosDB(List<Course> cursos) async {
    await _dao.deleteCourses(cursos);
  }

  Future<void> buidarCursosBD() async {
    await _dao.deleteCoursesAndItsContent();
  }

  Future<void> editarCursDB(Course curs) async {
    await _dao.updateCurs(curs);
  }
}
