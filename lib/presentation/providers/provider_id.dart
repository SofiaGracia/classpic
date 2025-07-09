import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xml_fotos/presentation/providers/repository.dart';
import '../../domain/entities/professor.dart';
import '../providers/professor_notifier.dart';
import 'alumne_notifier.dart';

final professorsIdsProvider = Provider<Set<int>>((ref) {
  final professors = ref.watch(professorNotifierProvider).value ?? [];
  return professors.map((p) => p.id!).toSet();
});


final alumnesIdsProvider = Provider.family<Set<int>, int>((ref, cursId) {
  final asyncAlumnes = ref.watch(alumnesNotifierProvider);
  return asyncAlumnes.when(
    data: (alumnes) {
      final alumnesFiltrats = alumnes.where((a) => a.cursId == cursId).toList();
      return alumnesFiltrats.map((a) => a.id!).toSet();
    },
    loading: () => <int>{},
    error: (err, stack) => <int>{},
  );
});
