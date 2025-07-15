
import 'package:xml_fotos/data/datasources/db/dao/teacher_dao.dart';

import '../../domain/entities/teacher.dart';

class TeacherRepository {

  final TeacherDao _dao;

  TeacherRepository(this._dao);

  Future<Teacher?> carregaProfessorDB(int id) async{
    return await _dao.findTeacherById(id);
  }

  Future<Teacher?> carregaProfessorDBbyDni(String dni) async{
    return await _dao.findTeacherByDni(dni);
  }

  Future<List<Teacher>> carregaProfessorsDB() async {
    final professors = await _dao.findAllTeachers();
    return professors;
  }

  Stream<List<int>> observeIdsTeacher() => _dao.observeIdsTeacher();

  Future<void> insertarProfessorDB(Teacher professor) async {
    await _dao.insertTeacher(professor);
  }

  Future<void> insertarProfessorsDB(List<Teacher> professors) async {
    await _dao.insertTeachers(professors);
  }

  Future<void> eliminarProfessorDB(Teacher professor) async {
    await _dao.deleteTeacher(professor);
  }

  Future<void> eliminarProfessorsDB(List<Teacher> professors) async {
    await _dao.deleteTeachers(professors);
  }

  Future<void> editarProfessorDB(Teacher professor) async {
    await _dao.updateTeacher(professor);
  }

  Future<void> editarProfessorsDB(List<Teacher> professors) async {
    await _dao.updateTeachers(professors);
  }

  Stream<List<String>> observeIdsProfessors() {
    return _dao.observeIdsTeacher();
  }
}