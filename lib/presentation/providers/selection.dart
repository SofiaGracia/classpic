import 'package:flutter_riverpod/flutter_riverpod.dart';

class SeleccioNotifier extends StateNotifier<Set<int>> {
  SeleccioNotifier() : super({});

  void toggle(int id) {
    if (state.contains(id)) {
      state = {...state}..remove(id);
    } else {
      state = {...state}..add(id);
    }
  }

  void clear() => state = {};

  bool isSelected(int id) => state.contains(id);
}

final seleccioCursosProvider =
StateNotifierProvider<SeleccioNotifier, Set<int>>((ref) => SeleccioNotifier());
