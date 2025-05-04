import 'package:xml_fotos/models/professor.dart';

abstract class IRepositoryProfessor {
  Future<List<Professor>> carregaLlistaProfessorsXml();
  Future<List<Professor>> carregaProfessorsFloor();
  Future<void> insertarProfessorFloor(Professor professor);
  Future<void> eliminarProfessorFloor(String nia);
  Future<void> editarProfessorFloor(Professor professor);
}
