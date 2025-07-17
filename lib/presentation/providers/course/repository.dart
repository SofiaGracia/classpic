import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/repository/course_db.dart';
import '../db/database.dart';

final courseRepositoryProvider = Provider<CourseRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return CourseRepository(db.courseDao);
});