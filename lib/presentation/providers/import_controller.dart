import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:classpic/presentation/providers/uri_notifier.dart';
import '../../data/datasources/xml/xml.dart';
import '../../application/services/alumne_import_handler.dart';
import '../../application/services/professor_import_handler.dart';
import '../../application/services/storage_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/errors/import.dart';

part 'import_controller.g.dart';

@riverpod
class ImportController extends _$ImportController {
  bool get isLoading => state.isLoading;

  Future<void> build() async {
    // No fem res ací; només gestionem estat des de l'onPressed.
  }

  Future<void> importaDades({required bool isAlumne}) async {
    try {

      //Necessite un directori base per a crear l'estructura de carpetes dels cursos dels alumnes importats
      final baseDir = await ref.read(UriProvider.notifier).getUri();

      if (baseDir == null) {
        throw DirectoriBaseNoTriat();
      }

      final doc = await ref.read(RepositoryXmlProvider).carregaInfo();

      // Si el XML és nul, també ho controlem (per si falla la càrrega)
      if (doc == null) {
        throw XmlNoCarregat();
      }

      final storage = ref.read(StorageServiceProvider);

      if (isAlumne) {
        final handler = AlumneImportHandler(ref, storage);
        await handler.processa(doc!);
      } else {
        final handler = ProfessorImportHandler(ref, storage);
        await handler.processa(doc!);
      }

      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

