import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xml_fotos/data/repository/student.dart';

import '../db/database.dart';

final studentRepositoryProvider = Provider<StudentRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return StudentRepository(db.studentDao);
});