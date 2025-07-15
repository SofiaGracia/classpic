import 'package:flutter/cupertino.dart';

import '../datasources/db/dao/curs_dao.dart';
import '../../domain/entities/course.dart';

class RepositoryCursDB {
  final CursDao _cursDao;

  RepositoryCursDB({
    required CursDao cursDao,
  }) : _cursDao = cursDao;

  //Potser carregar tots els cursos
  Future<List<Course>> carregarCursosDB() async {
    final cursos = await _cursDao.findAllCursos();
    return cursos;
  }

  Future<Course?> carregaCursDB(int id) async {
    return await _cursDao.findCursById(id);
  }

  Future<Course?> findCursNom(String nom) async {
    return await _cursDao.findCursByNom(nom);
  }

  Future<Course> insertarCursDB(Course curs) async {
    final id = await _cursDao.insertCurs(curs);
    return curs.copyWith(id: id);
  }

  Future<void> inserirCursosDB(List<Course> cursos) async {
    await _cursDao.insertCursos(cursos);
  }

  Future<void> imprimirCursosDB() async {
    final cursos = await _cursDao.findAllCursos();
    for (var c in cursos) {
      debugPrint('${c.id}: ${c.name}');
    }
  }

  Future<void> eliminarCursDB(Course curs) async {
    await _cursDao.deleteCurs(curs);
  }

  Future<void> eliminarCursosDB(List<Course> cursos) async {
    await _cursDao.deleteCursos(cursos);
  }

  Future<void> buidarCursosBD() async {
    await _cursDao.buidarCursos();
  }

  Future<void> editarCursDB(Course curs) async {
    await _cursDao.updateCurs(curs);
  }
}
