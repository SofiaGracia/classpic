
import '../datasources/db/dao/student_dao.dart';
import '../../domain/entities/student.dart';

class StudentRepository {

  final StudentDao _dao;

  StudentRepository(this._dao);

  Future<Student?> carregaAlumneDB(int id) async {
    return await _dao.findAlumneById(id);
  }

  //Carregar student per nia
  Future<Student?> carregaAlumneDBbyNia(String nia) async {
    return await _dao.findAlumneByNia(nia);
  }

  Future<List<Student>> carregaAlumnesDB() async {
    final alumnes = await _dao.findAllAlumnes();
    return alumnes;
  }

  Future<List<Student>> carregaAlumnesPerCursDB(int id) async {
    final alumnes = await _dao.obtenirAlumnesDelCurs(id);
    return alumnes;
  }

  Future<void> inserirAlumnesDB(List<Student> alumnesAInserir) async {
    await _dao.insertAlumnes(alumnesAInserir);
  }

  Future<int> insertarAlumneDB(Student alumne) async {
    final id = await _dao.insertAlumne(alumne);
    return id;
  }

  Future<void> eliminarAlumneDB(Student alumne) async {
    await _dao.deleteAlumne(alumne);
  }

  Future<void> eliminarAlumnesDB(List<Student> alumnesABorrar) async {
    await _dao.deleteAlumnes(alumnesABorrar);
  }

  Future<void> editarAlumneDB(Student alumne) async {
    await _dao.updateAlumne(alumne);
  }

  Future<void> editarAlumnesDB(List<Student> alumnes) async {
    await _dao.updateAlumnes(alumnes);
  }
}