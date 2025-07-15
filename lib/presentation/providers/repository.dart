import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xml_fotos/presentation/providers/stream_providers.dart';

import '../../data/datasources/db/dao/student_dao.dart';
import '../../data/datasources/db/dao/teacher_dao.dart';
import '../../data/datasources/db/database_service.dart';
import '../../data/repository/student.dart';
import '../../data/repository/teacher.dart';

//ALUMNE
/*final alumneDaoProvider = FutureProvider<AlumneDao>((ref) async {
  final dbService = DatabaseService();
  await dbService.connectaDB();
  return dbService.alumneDao;
});*/
/*
final repositoryAlumneDBProvider = Provider<StudentRepository>((ref) {
  //final dao = await ref.watch(alumneDaoProvider.future);
  final dao = DatabaseService().studentDao;
  return StudentRepository(studentDao: dao);
});
*/
//PROFESSOR
/*final professorDaoProvider = FutureProvider<ProfessorDao>((ref) async {
  final dbService = DatabaseService();
  await dbService.connectaDB();
  return dbService.professorDao;
});*/

/*final repositoryProfessorDBProvider = Provider<RepositoryProfessorDB>((ref) {
  final dao = DatabaseService().professorDao;
  return RepositoryProfessorDB(professorDao: dao);
});*/

/*final repositoryProfessorDBProvider = Provider<TeacherRepository>((ref) {
  final dao = ref.watch(professorDaoProvider);
  return TeacherRepository(teacherDao: dao);
});*/