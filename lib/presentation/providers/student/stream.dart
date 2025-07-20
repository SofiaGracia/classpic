
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xml_fotos/presentation/providers/student/repository.dart';

import '../../../domain/entities/student.dart';

final studentHasPhotoStreamProvider = StreamProvider.autoDispose<List<Student>?>((ref) {
  final repo = ref.watch(studentRepositoryProvider);
  return repo.streamStudentsWithPhoto();
});

final studentCourseHasPhotoStreamProvider =
StreamProvider.autoDispose.family<List<Student>?, int>((ref, courseId) {
  final repo = ref.watch(studentRepositoryProvider);
  return repo.streamStudentsCourseWithPhoto(courseId);
});