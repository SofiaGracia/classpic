
import 'package:xml_fotos/data/datasources/db/dao/professor_dao.dart';

import '../../domain/entities/professor.dart';

class RepositoryProfessorDB {

  final ProfessorDao _professorDao;

  RepositoryProfessorDB({
    required ProfessorDao professorDao,
  }) : _professorDao = professorDao;

  Future<List<Professor>> carregaProfessorsDB() async {
    final professors = await _professorDao.findAllProfessors();
    return professors;
  }

  Future<void> insertarProfessorDB(Professor professor) async {
    await _professorDao.insertProfessor(professor);
  }

  Future<void> insertarProfessorsDB(List<Professor> professors) async {
    await _professorDao.insertProfessors(professors);
  }

  Future<void> eliminarProfessorDB(Professor professor) async {
    await _professorDao.deleteProfessor(professor);
  }

  Future<void> eliminarProfessorsDB(List<Professor> professors) async {
    await _professorDao.deleteProfessors(professors);
  }

  Future<void> editarProfessorDB(Professor professor) async {
    await _professorDao.updateProfessor(professor);
  }

  Future<void> editarProfessorsDB(List<Professor> professors) async {
    await _professorDao.updateProfessors(professors);
  }

}