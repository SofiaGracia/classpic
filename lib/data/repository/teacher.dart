
import 'package:xml_fotos/data/datasources/db/dao/teacher_dao.dart';

import '../../domain/entities/teacher.dart';

class TeacherRepository {

  final TeacherDao _dao;

  TeacherRepository(this._dao);

  Future<Teacher?> carregaProfessorDB(int id) async{
    return await _dao.findProfessorById(id);
  }

  Future<Teacher?> carregaProfessorDBbyDni(String dni) async{
    return await _dao.findProfessorByDni(dni);
  }

  Future<List<Teacher>> carregaProfessorsDB() async {
    final professors = await _dao.findAllProfessors();
    return professors;
  }

  Future<void> insertarProfessorDB(Teacher professor) async {
    await _dao.insertProfessor(professor);
  }

  Future<void> insertarProfessorsDB(List<Teacher> professors) async {
    await _dao.insertProfessors(professors);
  }

  Future<void> eliminarProfessorDB(Teacher professor) async {
    await _dao.deleteProfessor(professor);
  }

  Future<void> eliminarProfessorsDB(List<Teacher> professors) async {
    await _dao.deleteProfessors(professors);
  }

  Future<void> editarProfessorDB(Teacher professor) async {
    await _dao.updateProfessor(professor);
  }

  Future<void> editarProfessorsDB(List<Teacher> professors) async {
    await _dao.updateProfessors(professors);
  }

  Stream<List<String>> observeIdsProfessors() {
    return _dao.observeIdsProfessors();
  }
}