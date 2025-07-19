
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xml_fotos/presentation/providers/student/repository.dart';

final studentHasPhotoStreamProvider = StreamProvider.autoDispose<int?>((ref) {
  final repo = ref.watch(studentRepositoryProvider);
  return repo.streamStudentsWithPhoto().distinct();
});

final studentCourseHasPhotoStreamProvider =
StreamProvider.autoDispose.family<int?, int>((ref, courseId) {
  final repo = ref.watch(studentRepositoryProvider);
  return repo.streamStudentsCourseWithPhoto(courseId).distinct();
});