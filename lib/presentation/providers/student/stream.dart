
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xml_fotos/presentation/providers/student/repository.dart';

final studentIdStreamProvider = StreamProvider.autoDispose.family<List<int?>, int?>((ref, courseId) {
  final repo = ref.watch(studentRepositoryProvider);
  return repo.observeTeacherIdsByCourse(courseId!);
});