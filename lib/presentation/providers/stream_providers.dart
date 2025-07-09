import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xml_fotos/presentation/providers/repository.dart';

final professorsIdsStreamProvider = StreamProvider<Set<int>>((ref) {
  final repo = ref.watch(repositoryProfessorDBProvider);
  return repo.observeIdsProfessors().map((ids) => ids.toSet());
});
