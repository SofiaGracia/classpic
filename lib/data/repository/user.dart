import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/student.dart';
import '../../domain/entities/teacher.dart';
import '../../presentation/providers/repository.dart';
import '../datasources/db/dao/alumne_dao.dart';
import '../datasources/db/dao/professor_dao.dart';
import '../datasources/db/database.dart';
/*
final userRepositoryProvider = FutureProvider<UserRepository>((ref) async {
  // Usa els DAOs ja exposats
  final alumneDao = await ref.watch(alumneDaoProvider.future);

  // Crea un provider semblant per al professorDao:
  final professorDao = await ref.watch(professorDaoProvider.future);

  return UserRepository(
    alumneDao: alumneDao,
    professorDao: professorDao,
  );
});


class UserRepository {
  final AlumneDao alumneDao;
  final ProfessorDao professorDao;

  UserRepository({
    required this.alumneDao,
    required this.professorDao,
  });

  Future<List<Alumne>> getAlumnesWithPhoto() async {
    final llistaAlumnes = await alumneDao.findAlumnesWithFoto();
    return llistaAlumnes;
  }

  Future<List<Professor>> getProfessorsWithPhoto() async {

    final llistaProfessors = await professorDao.findProfessorsWithFoto();
    return llistaProfessors;
  }
}*/
