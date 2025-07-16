
import '../datasources/db/dao/student_dao.dart';
import '../../domain/entities/student.dart';

class StudentRepository {

  final StudentDao _dao;

  StudentRepository(this._dao);

  Future<Student?> findStudentById(int id) async {
    return await _dao.findStudentById(id);
  }

  //Carregar student per nia
  Future<Student?> findStudentByNia(String nia) async {
    return await _dao.findStudentByNia(nia);
  }

  Future<List<Student>> findAllStudents() async {
    final alumnes = await _dao.findAllStudents();
    return alumnes;
  }

  Future<List<int>> getStudentsIdsByCourse(int courseId) async {
    final ids = await _dao.getStudetsIdsByCourse(courseId);
    return ids;
  }

  Future<List<Student>> getStudentsByCurs(int id) async {
    final alumnes = await _dao.getStudentsByCurs(id);
    return alumnes;
  }

  Stream<List<int?>> observeTeacherIdsByCourse(int courseId) => _dao.observeTeacherIdsByCourse(courseId);

  Future<void> insertStudents(List<Student> students) async {
    await _dao.insertStudents(students);
  }

  Future<int> insertStudent(Student student) async {
    final id = await _dao.insertStudent(student);
    return id;
  }

  Future<void> deleteStudent(Student student) async {
    await _dao.deleteStudent(student);
  }

  Future<void> deleteStudents(List<Student> students) async {
    await _dao.deleteStudents(students);
  }

  Future<void> updateStudent(Student student) async {
    await _dao.updateStudent(student);
  }

  Future<void> updateStudents(List<Student> students) async {
    await _dao.updateStudents(students);
  }
}