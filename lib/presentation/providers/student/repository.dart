import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:classpic/data/repository/student.dart';

import '../db/database.dart';

final studentRepositoryProvider = Provider<StudentRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return StudentRepository(db.studentDao);
});