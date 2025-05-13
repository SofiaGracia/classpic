import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xml/xml.dart';
import 'package:xml_fotos/application/services/storage_service.dart';

import '../../domain/entities/alumne.dart';
import '../../domain/entities/curs.dart';
import '../../presentation/providers/alumne_notifier.dart';
import '../../presentation/providers/cursos_notifier.dart';
import '../../data/datasources/xml/alumne_xml.dart';
import '../../shared/utils/change_group.dart';

class AlumneImportHandler {
  final Ref ref;
  final StorageService storage;

  AlumneImportHandler(this.ref, this.storage);

  Future<void> processa(XmlDocument doc) async {
    final alumneNot = ref.read(alumnesNotifierProvider.notifier);
    final alumnesDB = await ref.watch(alumnesTotsProvider.future);
    final repo = RepositoryAlumneXml(doc: doc);
    final parsed = repo.parseAlumnesFromXml(doc);

    final alumnesXml = parsed['alumnes'] as List<Alumne>;
    final cursosXml = parsed['cursos'] as Set<String>;

    if (alumnesDB.isEmpty) {
      final alumnes = await _importaPrimeraVegada(repo, alumnesXml, cursosXml);
      await alumneNot.inserirAlumnes(alumnes);
    } else {
      final alumnes = await _actualitzaAlumnes(repo, alumnesXml, alumnesDB, cursosXml);
      if (alumnes != null) await alumneNot.inserirAlumnes(alumnes);
    }
  }

  Future<List<Alumne>> _importaPrimeraVegada(
      RepositoryAlumneXml repo,
      List<Alumne> alumnesXml,
      Set<String> cursosXml,
      ) async {
    try{
      final cursosNot = ref.read(cursosNotifierProvider.notifier);
      await cursosNot.buidarCursos();

      await storage.creaEstructuraAlumnes(cursosXml);
      final cursos = cursosXml.map((nom) => Curs(nom: nom)).toList();
      await cursosNot.inserirCursos(cursos);

      final cursosDB = await ref.watch(cursTotsProvider.future);

      return await repo.assignaIdCursAlsAlumnes(alumnesXml, cursosDB);
    } catch (e) {
      throw Exception('Error a _importaPrimeraVegada: $e');
    }
  }

  Future<List<Alumne>?> _actualitzaAlumnes(
      RepositoryAlumneXml repo,
      List<Alumne> alumnesXml,
      List<Alumne> alumnesDB,
      Set<String> cursosXml,
      ) async {
    try {

      final cursosNot = ref.read(cursosNotifierProvider.notifier);
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
      await storage.creaEstructuraAlumnes(nomsNousCursos);

      final cursosActualitzats = await ref.watch(cursTotsProvider.future);
      // Alumnes a inserir o editar
      final alumneNot = await ref.read(alumnesNotifierProvider.notifier);
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
          final novaFotoPath = await storage.getPathAlumne(alum.grup!, existent.nom);

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
        await storage.eliminaFotos(fotoPaths);
        await alumneNot.eliminarAlumnes(alumnesAEliminar);
      }

      if (alumnesAEditar.isNotEmpty) await alumneNot.editarAlumnes(alumnesAEditar);

      await Future.wait(alumnesACanviar.map((alumne) {
        return storage.mouFotoAlumne(
          alumne.cursVell,
          alumne.cursNou,
          alumne.nomAlumne,
        );
      }));

      await storage.eliminaCarpetesAlumnes(nomsCursosABorrar);

      return alumnesAInserir;

    } catch (e, st) {
      debugPrint('Error a _actualitzaAlumnes: $e\n$st');
      return null;
    }
  }
}
