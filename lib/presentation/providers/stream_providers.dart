import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xml_fotos/presentation/providers/repository.dart';

import '../../data/datasources/db/dao/teacher_dao.dart';
import '../../data/datasources/db/database_service.dart';
import '../../data/repository/teacher.dart';

final databaseProvider = FutureProvider<DatabaseService>((ref) async {
  final dbService = DatabaseService();
  await dbService.connectDB(); // Obrir base de dades
  return dbService; // o on sigui que tens el AppDatabase
});

final professorDaoProvider = Provider<TeacherDao>((ref) {
  final dbAsync = ref.watch(databaseProvider);

  return dbAsync.maybeWhen(
    data: (db) => db.teacherDao,
    orElse: () => throw Exception('DB no inicialitzada encara'),
  );
});


final professorsIdsStreamProvider = StreamProvider<List<String>>((ref) async* {
  final dbService = DatabaseService();
  print('DB connectada: ${dbService.db != null}');
  final dao = dbService.teacherDao;
  print('Dao de professors: ${dbService.teacherDao != null}');
  yield* dao.observeIdsTeacher();
});
