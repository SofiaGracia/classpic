import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/user.dart';

class FotosTrencadesNotifier extends Notifier<List<User>> {
  @override
  List<User> build() => [];

  void addUser(User user) {
    if (!state.any((u) => u == user.idDB)) {
      state = [...state, user];
    }
  }

  void addUsers(List<User> users) {
    final idsExistents = state.map((u) => u..idDB).toSet();
    final nous = users.where((u) => !idsExistents.contains(u..idDB)).toList();
    state = [...state, ...nous];
  }

  void removeUser(int id) {
    state = state.where((u) => u.idDB != id).toList();
  }

  void clear() {
    state = [];
  }

  void replaceAll(List<User> nous) {
    state = [...nous];
  }
}

final fotosTrencadesProvider =
    NotifierProvider<FotosTrencadesNotifier, List<User>>(
  () => FotosTrencadesNotifier(),
);
