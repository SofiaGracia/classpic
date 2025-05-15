import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../application/services/storage_service.dart';
import '../../data/repository/curs_db.dart';
import '../../domain/entities/alumne.dart';
import '../../domain/entities/curs.dart';
import '../providers/alumne_notifier.dart';
import '../providers/cursos_notifier.dart';

part 'curs_controller.g.dart';

// Aquest és l'@riverpod correcte per a una classe amb build(int cursId)
@Riverpod(keepAlive: true) // Si vols mantenir-ho viu
CursController cursControllerId(CursControllerIdRef ref, int cursId) => throw UnimplementedError();

@riverpod
class CursController extends _$CursController {
  Curs? curs;

  Future<RepositoryCursDB> get _repo async => await ref.watch(repositoryCursDBProvider.future);

  Future<void> build(int cursId) async {
    curs = await ref.watch(cursPerIdProvider(cursId).future);
  }

  Future<void> editarNom(String nouNom) async {
    try {
      if (curs == null) return;
      final storageService = ref.read(StorageServiceProvider);
      await storageService.renombraCarpetaCurs(curs!.nom, nouNom);
      final nouCurs = curs!.copyWith(nom: nouNom);
      //await ref.read(cursosNotifierProvider.notifier).editarCurs(nouCurs);
      final repo = await _repo;
      await repo.editarCursDB(nouCurs);
      curs = nouCurs;

      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> eliminarCurs() async {
    try {
      if (curs == null) return;

      await ref.read(cursosNotifierProvider.notifier).eliminarCurs(curs!);
      await ref.read(StorageServiceProvider).eliminarFotosCarpetaCurs(curs!.nom);

      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

}
