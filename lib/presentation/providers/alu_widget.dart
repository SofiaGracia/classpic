// usuari_notifier.dart
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:xml_fotos/presentation/providers/repository.dart';

import '../../data/repository/alumne_db.dart';
import '../../domain/entities/alumne.dart';
import 'alumne_notifier.dart';

// usuari_notifier.dart
class AluWidgetNotifier extends AutoDisposeFamilyAsyncNotifier<Alumne, int> {
  late final int id;

  Future<RepositoryAlumneDB> get _repo async =>
      await ref.watch(repositoryAlumneDBProvider.future);

  @override
  FutureOr<Alumne> build(int arg) async {
    id = arg;
    final repo = await _repo;
    final alu = await repo.carregaAlumneDB(id);
    return alu!;
  }

  Future<void> actualitza(Alumne nou) async {

    final alu = state.value as Alumne;
    final actualitzat = alu.copyWith(
      id: alu.id,
      nia: nou.nia,
      nom: nou.nom,
      c1: nou.c1,
      c2: nou.c2,
      fotoPath: nou.fotoPath,
      fotoPathHash: nou.fotoPathHash,
    );

    //El que podem fer es comparar el cursId del nou i el cursId del vell i si canvia
    //canviar també el grup i cridar a la llista global i si no ha canviat cridar a la del propi widget

    //Problema amb la foto

    if(alu.cursId != nou.cursId){

      actualitzat.cursId = nou.cursId;
      actualitzat.grup = nou.grup;

      ref.read(alumnesNotifierProvider.notifier).actualitza(actualitzat);
    }else{

      final repo = await _repo;
      final alumneEditat = await repo.editarAlumneDB(actualitzat);
      ref.read(alumnesNotifierProvider.notifier).actualitza(actualitzat);
    }
    state = AsyncData(actualitzat);
  }
}

final alumneWidgetNotifierProvider = AsyncNotifierProvider.autoDispose
    .family<AluWidgetNotifier, Alumne, int>(AluWidgetNotifier.new);
