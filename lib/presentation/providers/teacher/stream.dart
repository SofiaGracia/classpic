
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xml_fotos/presentation/providers/teacher/repository.dart';

final teacherHasPhotoStreamProvider = StreamProvider.autoDispose<int?>((ref){
  final repo = ref.watch(teacherRepositoryProvider);
  return repo.streamTeachersWithPhoto().distinct();
});