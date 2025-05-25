import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/professor.dart';
import '../providers/professor_notifier.dart';
import 'alumne_notifier.dart';

final professorsIdsProvider = Provider<Set<int>>((ref) {
  final professors = ref.watch(professorNotifierProvider).value ?? [];
  return professors.map((p) => p.id!).toSet();
});


