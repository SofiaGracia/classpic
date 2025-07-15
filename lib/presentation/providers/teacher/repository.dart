import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/repository/teacher.dart';
import '../db/database.dart';

final teacherRepositoryProvider = Provider<TeacherRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return TeacherRepository(db.teacherDao);
});