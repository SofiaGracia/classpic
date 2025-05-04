/*import 'package:xml_fotos/database/dao/professor_dao.dart';
import 'package:xml_fotos/models/professor.dart';
import 'package:xml_fotos/repository/implementations/alumnes.dart';
import 'package:xml_fotos/database/dao/alumne_dao.dart';
import 'package:xml_fotos/models/alumne.dart';
import 'package:xml_fotos/repository/implementations/professor.dart';
import 'package:xml_fotos/service/interfaces/iprofessor_service.dart';

import '../interfaces/ialumne_service.dart';

class ProfessorService implements IprofessorService {
  final RepositoryProfessor repo;
  final ProfessorDao dao;

  ProfessorService(this.repo, this.dao);

  @override
  Future<List<Professor>> carregaIInsereixProfessors() async {
    final profes = await repo.carregaLlistaProfessors();
    await dao.insertProfessors(profes);
    return profes;
  }

  /*@override
  Future<int> comptaAlumnesAmbFoto() async {
    final alumnes = await dao.getAllAlumnes();
    return alumnes.where((a) => a.fotoPath != null && a.fotoPath!.isNotEmpty).length;
  }*/

  //Ací vull passar-li la llista de alumnes per argument
  @override
  Future<int> comptaProfessorsSenseFoto() async {
    final profes = await dao.findAllProfessors();
    return profes.where((a) => a.fotoPath == null || a.fotoPath!.isEmpty).length;
  }
}*/
