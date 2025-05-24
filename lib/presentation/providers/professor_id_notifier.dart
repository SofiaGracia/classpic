import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/professor.dart';
import '../providers/professor_notifier.dart';

/*class ProfessorsIdsNotifier extends AsyncNotifier<Set<int>> {
  @override
  Future<Set<int>> build() async {
    final professors = await ref.watch(professorNotifierProvider).value ?? [];
    return professors.map((p) => p.id!).toSet();
  }
}

final professorsIdsProvider =
AsyncNotifierProvider<ProfessorsIdsNotifier, Set<int>>(ProfessorsIdsNotifier.new);*/

final professorsIdsProvider = Provider<Set<int>>((ref) {
  final professors = ref.watch(professorNotifierProvider).value ?? [];
  return professors.map((p) => p.id!).toSet();
});
