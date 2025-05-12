import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xml/xml.dart';
import 'package:xml_fotos/providers/alumne_notifier.dart';
import 'package:xml_fotos/providers/professor_notifier.dart';
import 'package:xml_fotos/utils/change_group.dart';

import '../database/dao/curs_dao.dart';
import '../models/alumne.dart';
import '../models/curs.dart';
import '../models/professor.dart';
import '../repository/alumne_xml.dart';
import '../repository/curs_db.dart';
import '../repository/database.dart';
import '../repository/implementations/xml.dart';
import '../repository/professor_xml.dart';
import '../service/storage_service.dart';
import 'cursos_notifier.dart';

final cursDaoProvider = FutureProvider<CursDao>((ref) async {
  final dbService = DatabaseService();
  await dbService.connectaDB();
  return dbService.cursDao;
});

final importControllerProvider =
AsyncNotifierProvider<ImportController, void>(() => ImportController());


class ImportController extends AsyncNotifier<void> {
  bool get isLoading => state.isLoading;

  @override
  Future<void> build() async {
    // No fem res ací; només gestionem estat des de l'onPressed.
  }

  Future<void> importaDades({required bool isAlumne}) async {
    try {
      final doc = await ref.read(RepositoryXmlProvider).carregaInfo();

      if (isAlumne) {
        await _importaAlumnes(doc!);
      } else {
        await _importaProfessors(doc!);
      }

      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> _importaProfessors(XmlDocument doc) async {
    state = const AsyncLoading();

    final storageService = ref.read(StorageServiceProvider);

    //El que volem saber és si existeixen professors o no
    //És correcte que ho haja de saber desde l'estat?
    final profNot = ref.read(professorNotifierProvider.notifier);
    //Ací potser hem de cridar a profNot.carregarProfessors() abans d'obtindre el state
    final professorsDB = profNot.state.requireValue;
    final professorsXml = await RepositoryProfessorXml(doc: doc).carregaLlistaProfessorsXml();

    if (professorsDB.isEmpty) {
      await storageService.creaEstructuraProfessors();
      await profNot.inserirProfessors(professorsXml);
    } else {

      final profDBSet = professorsDB.map((e) => e.dni).toSet();
      final pAfegir = professorsXml.where((p) => !profDBSet.contains(p.dni)).toList();
      final pEliminar = professorsDB.where((p) => !professorsXml.any((px) => px.dni == p.dni)).toList();

      if (pAfegir.isNotEmpty) await profNot.inserirProfessors(pAfegir);
      if (pEliminar.isNotEmpty){
        List<String> fotoPaths = [];
        for(final p in pEliminar){
          if(p.fotoPath != null){
            fotoPaths.add(p.fotoPath!);
          }
        }
        await storageService.eliminaFotos(fotoPaths);
        await profNot.eliminarProfessors(pEliminar);
      }
    }
  }

  Future<void> _importaAlumnes(XmlDocument doc) async {

    //Possem l'estat a carregar
    state = const AsyncLoading();

    final storageService = ref.read(StorageServiceProvider);

    //Obtenim quants alumnes tenim a la base de dades
    final alumneNot = await ref.read(alumnesNotifierProvider.notifier);
    final alumnesDB = await ref.watch(alumnesTotsProvider.future);

    //Parsegem per traure els alumnes i els cursos del Xml
    final repo = RepositoryAlumneXml(doc: doc);
    final alumnesICursos = repo.parseAlumnesFromXml(doc);
    final alumnesXml = alumnesICursos['alumnes'] as List<Alumne>;
    final cursosXml = alumnesICursos['cursos'] as Set<String>;

    final alumnesAInserir = alumnesDB.isEmpty
        ? await _importaPrimeraVegada(repo, storageService, alumnesXml, cursosXml)
        : await _actualitzaAlumnes(alumneNot, repo, alumnesXml, alumnesDB, cursosXml);

    if (alumnesAInserir != null) await alumneNot.inserirAlumnes(alumnesAInserir);
    //final alumnesALaBD = await ref.watch(alumnesTotsProvider.future);

    /*debugPrint('PRINT DE _importaAlumnes');
    for(Alumne alumne in alumnesALaBD){
      debugPrint('${alumne.id} ${alumne.nom} ${alumne.grup}');
    }*/
  }

  //Realment no fa falta que li passem cursosNot
  //pq és un notifier de Riverpod i no està en l'arbre de widgets
  //per tant el podem cridar desde qualsevol puesto
  Future<List<Alumne>> _importaPrimeraVegada(
      RepositoryAlumneXml repo,
      StorageService storageService,
      List<Alumne> alumnesXml,
      Set<String> cursosXml,
      ) async {
    try{
      final cursosNot = ref.read(cursosNotifierProvider.notifier);
      await cursosNot.buidarCursos();

      //Estos dos els haurem d'eliminar
      final cursosIsBuit = await ref.watch(cursTotsProvider.future);
      debugPrint('${cursosIsBuit.isEmpty}');

      await storageService.creaEstructuraAlumnes(cursosXml);
      final cursos = cursosXml.map((nom) => Curs(nom: nom)).toList();
      await cursosNot.inserirCursos(cursos);

      final cursosDB = await ref.watch(cursTotsProvider.future);

      final alumnesAmbId = await repo.assignaIdCursAlsAlumnes(alumnesXml, cursosDB);
      return alumnesAmbId; //També podem fer un return directe de la funció
    } catch (e, st) {
      throw Exception('Error a _importaPrimeraVegada: $e');
    }
  }

  Future<List<Alumne>?> _actualitzaAlumnes(
      AlumnesNotifier alumneNot,
      RepositoryAlumneXml repo,
      List<Alumne> alumnesXml,
      List<Alumne> alumnesDB,
      Set<String> cursosXml,
      ) async {
    try {

      final cursosNot = ref.read(cursosNotifierProvider.notifier);
      final storageServiceProvider = ref.read(StorageServiceProvider);

      final cursosNous = cursosXml.map((nom) => Curs(nom: nom)).toList();
      final cursosActuals = await ref.watch(cursTotsProvider.future);

      final nomsActuals = cursosActuals.map((c) => c.nom).toSet();
      final cursosPerAfegir = cursosNous.where((nou) => !nomsActuals.contains(nou.nom)).toList();

      final nomsNous = cursosNous.map((c) => c.nom).toSet();
      final cursosPerEsborrar = cursosActuals.where((actual) => !nomsNous.contains(actual.nom)).toList();

      //Esborrem i inserim
      await cursosNot.eliminarCursos(cursosPerEsborrar);
      //Ací borrariem els directoris antics
      final nomsCursosABorrar = cursosPerEsborrar.map((c) => c.nom).toSet();
      //Encara no esborrem els cursos pq necessitem passar les fotos

      await cursosNot.inserirCursos(cursosPerAfegir);
      //Ací creariem els directoris nous
      final nomsNousCursos = cursosPerAfegir.map((c) => c.nom).toSet();
      await storageServiceProvider.creaEstructuraAlumnes(nomsNousCursos);

      final cursosActualitzats = await ref.watch(cursTotsProvider.future);
      // Alumnes a inserir o editar
      final alumnesDBMap = {for (final a in alumnesDB) a.nia: a};
      final alumnesAInserir = <Alumne>[];
      final alumnesAEditar = <Alumne>[];
      final alumnesNiesXml = alumnesXml.map((a) => a.nia).toSet();

      final alumnesXmlAmbId = await repo.assignaIdCursAlsAlumnes(alumnesXml, cursosActualitzats);
      List<CanviDeCursAlumne> alumnesACanviar = [];

      for (final alum in alumnesXmlAmbId) {
        final existent = alumnesDBMap[alum.nia];
        if (existent == null) {
          alumnesAInserir.add(alum);
        } else if (existent.cursId != alum.cursId) {

          alumnesACanviar.add(CanviDeCursAlumne(cursVell: existent.grup!, cursNou: alum.grup!, nomAlumne: existent.nom));
          final novaFotoPath = await storageServiceProvider.getPathAlumne(alum.grup!, existent.nom);

          final alumneAmbCursCanviat = alum.copyWith(id: existent.id, fotoPath: novaFotoPath);

          alumnesAEditar.add(alumneAmbCursCanviat);
        }
      }
      // Alumnes que s'han d'eliminar
      final alumnesAEliminar = alumnesDB.where((a) => !alumnesNiesXml.contains(a.nia)).toList();

      if (alumnesAEliminar.isNotEmpty){
        List<String> fotoPaths = [];
        for(final a in alumnesAEliminar){
          if(a.fotoPath != null){
            fotoPaths.add(a.fotoPath!);
          }
        }
        await storageServiceProvider.eliminaFotos(fotoPaths);
        await alumneNot.eliminarAlumnes(alumnesAEliminar);
      }

      if (alumnesAEditar.isNotEmpty) await alumneNot.editarAlumnes(alumnesAEditar);

      await Future.wait(alumnesACanviar.map((alumne) {
        return storageServiceProvider.mouFotoAlumne(
          alumne.cursVell,
          alumne.cursNou,
          alumne.nomAlumne,
        );
      }));


      //Val, ací ja podria eliminar els cursos vells no?
      await storageServiceProvider.eliminaCarpetesAlumnes(nomsCursosABorrar);

      return alumnesAInserir;

    } catch (e, st) {
      debugPrint('Error a _actualitzaAlumnes: $e\n$st');
      return null;
    }
  }
}

