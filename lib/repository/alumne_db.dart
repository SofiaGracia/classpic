
import '../database/dao/alumne_dao.dart';
import '../models/alumne.dart';

class RepositoryAlumneDB {

  final AlumneDao _alumneDao;

  RepositoryAlumneDB({
    required AlumneDao alumneDao,
  }) : _alumneDao = alumneDao;

  Future<List<Alumne>> carregaAlumnesDB() async {
    final alumnes = await _alumneDao.findAllAlumnes();
    return alumnes;
  }

  Future<void> inserirAlumnesDB(List<Alumne> alumnesAInserir) async {
    await _alumneDao.insertAlumnes(alumnesAInserir);
  }

  Future<void> insertarAlumneDB(Alumne alumne) async {
    await _alumneDao.insertAlumne(alumne);
  }

  Future<void> eliminarAlumneDB(Alumne alumne) async {
    await _alumneDao.deleteAlumne(alumne);
  }

  Future<void> editarAlumneDB(Alumne alumne) async {
    await _alumneDao.updateAlumne(alumne);
  }

}