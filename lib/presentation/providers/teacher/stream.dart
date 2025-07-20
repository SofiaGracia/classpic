
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xml_fotos/presentation/providers/teacher/repository.dart';

import '../../../domain/entities/teacher.dart';

final teacherHasPhotoStreamProvider = StreamProvider.autoDispose<List<Teacher>?>((ref){
  final repo = ref.watch(teacherRepositoryProvider);
  return repo.streamTeachersWithPhoto();
});