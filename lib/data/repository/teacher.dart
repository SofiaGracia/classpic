
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

  //Get all the teacher's ids
  Future<List<int>> getAllIdsTeacher() async {
    final ids = await _dao.getAllIdsTeacher();
    return ids;
  }

  Stream<List<Teacher>?> streamTeachersWithPhoto() => _dao.streamTeachersWithPhoto();

  Stream<List<Teacher>> getStreamedTeachersByName(String name) => _dao.findTeachersByName(name);

  Future<void> insertTeacher(Teacher professor) async {
    await _dao.insertTeacher(professor);
  }

  Future<void> insertarProfessorsDB(List<Teacher> professors) async {
    await _dao.insertTeachers(professors);
  }

  Future<void> deleteTeacher(Teacher professor) async {
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
}