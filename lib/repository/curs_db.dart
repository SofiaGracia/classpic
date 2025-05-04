import '../database/dao/curs_dao.dart';
import '../models/curs.dart';

class RepositoryCursDB {
  final CursDao _cursDao;

  RepositoryCursDB({
    required CursDao cursDao,
  }) : _cursDao = cursDao;

  //Potser carregar tots els cursos
  Future<List<Curs>> carregarCursDB() async {
    final cursos = await _cursDao.findAllCursos();
    return cursos;
  }

  Future<Curs> insertarCursDB(Curs curs) async {
    final id = await _cursDao.insertCurs(curs);
    return curs.copyWith(id: id);
  }

  Future<void> inserirCursosDB(List<Curs> cursos) async {
    await _cursDao.insertCursos(cursos);
  }

  Future<void> eliminarCursDB(Curs curs) async {
    await _cursDao.deleteCurs(curs);
  }

  Future<void> editarCursDB(Curs curs) async {
    await _cursDao.updateCurs(curs);
  }
}
