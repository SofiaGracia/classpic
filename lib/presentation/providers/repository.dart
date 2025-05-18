import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/db/dao/alumne_dao.dart';
import '../../data/datasources/db/dao/professor_dao.dart';
import '../../data/datasources/db/database_service.dart';
import '../../data/repository/alumne_db.dart';
import '../../data/repository/professor_db.dart';

//ALUMNE
final alumneDaoProvider = FutureProvider<AlumneDao>((ref) async {
  final dbService = DatabaseService();
  await dbService.connectaDB();
  return dbService.alumneDao;
});

final repositoryAlumneDBProvider = FutureProvider<RepositoryAlumneDB>((ref) async {
  final dao = await ref.watch(alumneDaoProvider.future);
  return RepositoryAlumneDB(alumneDao: dao);
});

//PROFESSOR
final professorDaoProvider = FutureProvider<ProfessorDao>((ref) async {
  final dbService = DatabaseService();
  await dbService.connectaDB();
  return dbService.professorDao;
});

final repositoryProfessorDBProvider = FutureProvider<RepositoryProfessorDB>((ref) async {
  final dao = await ref.watch(professorDaoProvider.future);
  return RepositoryProfessorDB(professorDao: dao);
});