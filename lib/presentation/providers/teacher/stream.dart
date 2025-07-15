
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xml_fotos/presentation/providers/teacher/repository.dart';

import '../../../domain/entities/teacher.dart';

final teacherIdStreamProvider = StreamProvider.autoDispose<List<int?>>((ref) {
  final repo = ref.watch(teacherRepositoryProvider);
  return repo.observeIdsTeacher();
});

final teacherStreamProvider = StreamProvider.autoDispose<List<Teacher>>((ref) {
  final repo = ref.watch(teacherRepositoryProvider);
  return repo.getAllStreamedTeachers();
});