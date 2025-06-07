import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:xml_fotos/presentation/providers/repository.dart';

import '../../data/repository/alumne_db.dart';
import '../../domain/entities/alumne.dart';
import 'alumne_notifier.dart';

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

    var cridarGlobal = false;

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

    //Si se li ha canviat el path de la foto
    // (abans no tenia i ara sí també hem de cridar al mètode de la llista global)
    // Hem de comparar-ho per fotoPathHash

    //Comparem el cursId nou i el vell per si canvia
    //si canvia és que ha canviat de grup i hem de cridar al mètode actualitza de la llista global

    if(alu.cursId != nou.cursId){
      cridarGlobal = true;
      actualitzat.cursId = nou.cursId;
      actualitzat.grup = nou.grup;
    }

    if(alu.fotoPathHash != nou.fotoPathHash){
      cridarGlobal = true;
    }

    if(cridarGlobal){
      ref.read(alumnesNotifierProvider.notifier).actualitza(actualitzat);
    }else{
      final repo = await _repo;
      final alumneEditat = await repo.editarAlumneDB(actualitzat);
    }
    state = AsyncData(actualitzat);
  }
}
final alumneWidgetNotifierProvider = AsyncNotifierProvider.autoDispose
    .family<AluWidgetNotifier, Alumne, int>(AluWidgetNotifier.new);
