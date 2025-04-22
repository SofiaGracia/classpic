import 'package:xml_fotos/models/professor.dart';

abstract class IRepositoryProfessor {
  Future<List<Professor>> carregaLlistaProfessors();
}
