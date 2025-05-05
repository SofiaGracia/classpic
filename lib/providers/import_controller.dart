import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xml/xml.dart';
import 'package:xml_fotos/providers/alumne_notifier.dart';
import 'package:xml_fotos/providers/professor_notifier.dart';

import '../database/dao/curs_dao.dart';
import '../models/curs.dart';
import '../repository/alumne_xml.dart';
import '../repository/curs_db.dart';
import '../repository/database.dart';
import '../repository/implementations/xml.dart';
import '../repository/professor_xml.dart';
import 'cursos_notifier.dart';

final cursDaoProvider = FutureProvider<CursDao>((ref) async {
  final dbService = DatabaseService();
  await dbService.connectaDB();
  return dbService.cursDao;
});

class ImportController extends AsyncNotifier<void> {
  bool get isLoading => state.isLoading;

  @override
  Future<void> build() async {
    // No fem res ací; només gestionem estat des de l'onPressed.
  }

  Future<void> importaDades({required bool isAlumne}) async {

    try {
      final repoXml = RepositoryXml();
      final doc = await repoXml.carregaInfo();

      if (isAlumne) {
        state = const AsyncLoading();
        final repo = RepositoryAlumneXml(doc: doc!);
        final alumnesICursos = repo.parseAlumnesFromXml(doc);
        //Ara el que necessitem és inserir cursos per a que els cursos tinguen el seu id
        final cursos = (alumnesICursos['cursos'] as Set<String>)
            .map((nom) => Curs(nom: nom))
            .toList();
        final cursosNotifier = ref.read(cursosNotifierProvider.notifier);
        await cursosNotifier.inserirCursos(cursos);
        await cursosNotifier.carregarCursos();
        final cursosDB = await ref.read(cursosNotifierProvider.future);

        //Ara que ja están inserits podem assigarnar-los als alumnes
        final alumnes = alumnesICursos['alumnes'];
        final alumnesAmbId = await repo.assignaIdCursAlsAlumnes(alumnes, cursosDB);

        //I ara que ja tenim els alumnes ara podem inserir-los en la base de dades
        await ref.read(alumnesNotifierProvider.notifier).inserirAlumnes(alumnesAmbId);

        //A mode de debug:
        final repoCurs = await ref.watch(repositoryCursDBProvider.future);
        await repoCurs.imprimirCursosDB();

      } else {
        state = const AsyncLoading();
        final professors = await RepositoryProfessorXml(doc: doc!).carregaLlistaProfessorsXml();
        await ref.read(professorNotifierProvider.notifier).inserirProfessors(professors);
      }

      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

final importControllerProvider =
AsyncNotifierProvider<ImportController, void>(() => ImportController());
