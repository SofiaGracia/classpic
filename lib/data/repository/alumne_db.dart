
import '../datasources/db/dao/alumne_dao.dart';
import '../../domain/entities/alumne.dart';

class RepositoryAlumneDB {

  final AlumneDao _alumneDao;

  RepositoryAlumneDB({
    required AlumneDao alumneDao,
  }) : _alumneDao = alumneDao;

  Future<Alumne?> carregaAlumneDB(int id) async {
    return await _alumneDao.findAlumneById(id);
  }

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

  Future<void> eliminarAlumnesDB(List<Alumne> alumnesABorrar) async {
    await _alumneDao.deleteAlumnes(alumnesABorrar);
  }

  Future<void> editarAlumneDB(Alumne alumne) async {
    await _alumneDao.updateAlumne(alumne);
  }

  Future<void> editarAlumnesDB(List<Alumne> alumnes) async {
    await _alumneDao.updateAlumnes(alumnes);
  }
}