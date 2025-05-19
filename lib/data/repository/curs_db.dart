import 'package:flutter/cupertino.dart';

import '../datasources/db/dao/curs_dao.dart';
import '../../domain/entities/curs.dart';

class RepositoryCursDB {
  final CursDao _cursDao;

  RepositoryCursDB({
    required CursDao cursDao,
  }) : _cursDao = cursDao;

  //Potser carregar tots els cursos
  Future<List<Curs>> carregarCursosDB() async {
    final cursos = await _cursDao.findAllCursos();
    return cursos;
  }

  Future<Curs?> carregaCursDB(int id) async {
    return await _cursDao.findCursById(id);
  }

  Future<Curs> insertarCursDB(Curs curs) async {
    final id = await _cursDao.insertCurs(curs);
    return curs.copyWith(id: id);
  }

  Future<void> inserirCursosDB(List<Curs> cursos) async {
    await _cursDao.insertCursos(cursos);
  }

  Future<void> imprimirCursosDB() async {
    final cursos = await _cursDao.findAllCursos();
    for (var c in cursos) {
      debugPrint('${c.id}: ${c.nom}');
    }
  }

  Future<void> eliminarCursDB(Curs curs) async {
    await _cursDao.deleteCurs(curs);
  }

  Future<void> eliminarCursosDB(List<Curs> cursos) async {
    await _cursDao.deleteCursos(cursos);
  }

  Future<void> buidarCursosBD() async {
    await _cursDao.buidarCursos();
  }

  Future<void> editarCursDB(Curs curs) async {
    await _cursDao.updateCurs(curs);
  }
}
