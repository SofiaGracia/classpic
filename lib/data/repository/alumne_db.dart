
import '../datasources/db/dao/alumne_dao.dart';
import '../../domain/entities/student.dart';

class RepositoryAlumneDB {

  final AlumneDao _alumneDao;

  RepositoryAlumneDB({
    required AlumneDao alumneDao,
  }) : _alumneDao = alumneDao;

  Future<Student?> carregaAlumneDB(int id) async {
    return await _alumneDao.findAlumneById(id);
  }

  //Carregar alumne per nia
  Future<Student?> carregaAlumneDBbyNia(String nia) async {
    return await _alumneDao.findAlumneByNia(nia);
  }

  Future<List<Student>> carregaAlumnesDB() async {
    final alumnes = await _alumneDao.findAllAlumnes();
    return alumnes;
  }

  Future<List<Student>> carregaAlumnesPerCursDB(int id) async {
    final alumnes = await _alumneDao.obtenirAlumnesDelCurs(id);
    return alumnes;
  }

  Future<void> inserirAlumnesDB(List<Student> alumnesAInserir) async {
    await _alumneDao.insertAlumnes(alumnesAInserir);
  }

  Future<int> insertarAlumneDB(Student alumne) async {
    final id = await _alumneDao.insertAlumne(alumne);
    return id;
  }

  Future<void> eliminarAlumneDB(Student alumne) async {
    await _alumneDao.deleteAlumne(alumne);
  }

  Future<void> eliminarAlumnesDB(List<Student> alumnesABorrar) async {
    await _alumneDao.deleteAlumnes(alumnesABorrar);
  }

  Future<void> editarAlumneDB(Student alumne) async {
    await _alumneDao.updateAlumne(alumne);
  }

  Future<void> editarAlumnesDB(List<Student> alumnes) async {
    await _alumneDao.updateAlumnes(alumnes);
  }
}