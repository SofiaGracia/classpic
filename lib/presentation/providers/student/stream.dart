
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xml_fotos/presentation/providers/student/repository.dart';

import '../../../domain/entities/student.dart';

class StreamParams {
  final int courseId;
  final String name;

  const StreamParams(this.courseId, this.name);
}

final studentHasPhotoStreamProvider = StreamProvider.autoDispose<List<Student>?>((ref) {
  final repo = ref.watch(studentRepositoryProvider);
  return repo.streamStudentsWithPhoto();
});

final studentCourseHasPhotoStreamProvider =
StreamProvider.autoDispose.family<List<Student>?, int>((ref, courseId) {
  final repo = ref.watch(studentRepositoryProvider);
  return repo.streamStudentsCourseWithPhoto(courseId);
});

/*final studentSearchStreamProvider =
StreamProvider.autoDispose.family<List<Student>?, StreamParams>(
      (ref, params) {
    final repo = ref.watch(studentRepositoryProvider);
    return repo.getStreamedStudents(params.courseId, params.name);
  },
);*/

final studentSearchStreamProvider =
StreamProvider.autoDispose.family<List<Student>, (int, String)>((ref, params) {
  final repo = ref.watch(studentRepositoryProvider);
  return repo.getStreamedStudents(params.$1, params.$2);
});
