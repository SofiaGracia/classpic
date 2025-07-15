
import 'package:xml_fotos/data/datasources/db/dao/professor_dao.dart';

import '../../domain/entities/teacher.dart';

class RepositoryProfessorDB {

  final ProfessorDao _professorDao;

  RepositoryProfessorDB({
    required ProfessorDao professorDao,
  }) : _professorDao = professorDao;

  Future<Teacher?> carregaProfessorDB(int id) async{
    return await _professorDao.findProfessorById(id);
  }

  Future<Teacher?> carregaProfessorDBbyDni(String dni) async{
    return await _professorDao.findProfessorByDni(dni);
  }

  Future<List<Teacher>> carregaProfessorsDB() async {
    final professors = await _professorDao.findAllProfessors();
    return professors;
  }

  Future<void> insertarProfessorDB(Teacher professor) async {
    await _professorDao.insertProfessor(professor);
  }

  Future<void> insertarProfessorsDB(List<Teacher> professors) async {
    await _professorDao.insertProfessors(professors);
  }

  Future<void> eliminarProfessorDB(Teacher professor) async {
    await _professorDao.deleteProfessor(professor);
  }

  Future<void> eliminarProfessorsDB(List<Teacher> professors) async {
    await _professorDao.deleteProfessors(professors);
  }

  Future<void> editarProfessorDB(Teacher professor) async {
    await _professorDao.updateProfessor(professor);
  }

  Future<void> editarProfessorsDB(List<Teacher> professors) async {
    await _professorDao.updateProfessors(professors);
  }

  Stream<List<String>> observeIdsProfessors() {
    return _professorDao.observeIdsProfessors();
  }
}