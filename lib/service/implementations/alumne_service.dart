import 'package:xml_fotos/repository/implementations/alumnes.dart';
import 'package:xml_fotos/database/dao/alumne_dao.dart';
import 'package:xml_fotos/models/alumne.dart';

import '../interfaces/ialumne_service.dart';

class AlumneService implements IAlumneService {
  final RepositoryAlumne repo;
  final AlumneDao dao;

  AlumneService(this.repo, this.dao);

  @override
  Future<List<Alumne>> carregaIInsereixAlumnes() async {
    final alumnes = await repo.carregaLlistaAlumnes();
    await dao.insertAlumnes(alumnes); // o una a una si no tens funció de llista
    return alumnes;
  }

  /*@override
  Future<int> comptaAlumnesAmbFoto() async {
    final alumnes = await dao.getAllAlumnes();
    return alumnes.where((a) => a.fotoPath != null && a.fotoPath!.isNotEmpty).length;
  }*/

  //Ací vull passar-li la llista de alumnes per argument
  @override
  Future<int> comptaAlumnesSenseFoto() async {
    final alumnes = await dao.findAllAlumnes();
    return alumnes.where((a) => a.fotoPath == null || a.fotoPath!.isEmpty).length;
  }
}
