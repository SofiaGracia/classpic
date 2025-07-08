import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/usuari.dart';

class FotosTrencadesNotifier extends Notifier<List<Usuari>> {
  @override
  List<Usuari> build() => [];

  void addUser(Usuari user) {
    if (!state.any((u) => u == user.idDB)) {
      state = [...state, user];
    }
  }

  void addUsers(List<Usuari> users) {
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

  void replaceAll(List<Usuari> nous) {
    state = [...nous];
  }
}

final fotosTrencadesProvider =
    NotifierProvider<FotosTrencadesNotifier, List<Usuari>>(
  () => FotosTrencadesNotifier(),
);
