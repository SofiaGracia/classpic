import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xml_fotos/presentation/providers/stream_providers.dart';

import '../../data/datasources/db/dao/alumne_dao.dart';
import '../../data/datasources/db/dao/professor_dao.dart';
import '../../data/datasources/db/database_service.dart';
import '../../data/repository/alumne_db.dart';
import '../../data/repository/professor_db.dart';

//ALUMNE
/*final alumneDaoProvider = FutureProvider<AlumneDao>((ref) async {
  final dbService = DatabaseService();
  await dbService.connectaDB();
  return dbService.alumneDao;
});*/

final repositoryAlumneDBProvider = Provider<RepositoryAlumneDB>((ref) {
  //final dao = await ref.watch(alumneDaoProvider.future);
  final dao = DatabaseService().alumneDao;
  return RepositoryAlumneDB(alumneDao: dao);
});

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

final repositoryProfessorDBProvider = Provider<RepositoryProfessorDB>((ref) {
  final dao = ref.watch(professorDaoProvider);
  return RepositoryProfessorDB(professorDao: dao);
});