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


/// Classe encarregada de gestionar la importació d'alumnes a partir d'un fitxer XML
class AlumneImportHandler {
  final Ref ref;
  final StorageService storage;

  /// Constructor que rep una referència de Riverpod i el servei d'emmagatzematge
  AlumneImportHandler(this.ref, this.storage);

  /// Funció principal que processa el document XML
  Future<void> processa(XmlDocument doc) async {
    final alumneNot = ref.read(alumnesNotifierProvider.notifier);

    // Obté els alumnes de la base de dades sense modificar l'estat del provider
    final alumnesDB = await ref.read(alumnesNotifierProvider.notifier).getAlumnesSenseModificarState();

    // Crea el repositori per llegir els alumnes del fitxer XML
    final repo = RepositoryAlumneXml(doc: doc);
    final parsed = repo.parseAlumnesFromXml(doc);

    final alumnesXml = parsed['alumnes'] as List<Alumne>;
    final cursosXml = parsed['cursos'] as Set<String>;

    if (alumnesDB.isEmpty) {

      // Si no hi ha alumnes a la base de dades, és la primera importació
      final alumnes = await _importaPrimeraVegada(repo, alumnesXml, cursosXml);
      await alumneNot.inserirAlumnes(alumnes);
    } else {

      // Si ja hi ha alumnes, es fa una actualització
      final alumnes = await actualitzaAlumnes(repo, alumnesXml, alumnesDB, cursosXml);
      if (alumnes != null) await alumneNot.inserirAlumnes(alumnes);
    }
  }

  /// Importació inicial: crea cursos, carpetes i assigna alumnes
  Future<List<Alumne>> _importaPrimeraVegada(
      RepositoryAlumneXml repo,
      List<Alumne> alumnesXml,
      Set<String> cursosXml,
      ) async {
    try{
      final cursosNot = ref.read(cursosNotifierProvider.notifier);

      // Buida els cursos existents
      await cursosNot.buidarCursos();

      // Crea l'estructura de carpetes per als cursos nous
      await storage.creaEstructuraAlumnes(cursosXml);

      // Insereix els cursos a la base de dades
      final cursos = cursosXml.map((nom) => Curs(nom: nom)).toList();
      await cursosNot.inserirCursos(cursos);
      // Obté els cursos actuals per poder assignar l’ID del curs als alumnes
      final cursosDB = await ref.read(cursosNotifierProvider.notifier).getCursosSenseModificarState();
      // Assigna ID de curs als alumnes
      return await repo.assignaIdCursAlsAlumnes(alumnesXml, cursosDB);
    } catch (e) {
      throw Exception('Error a _importaPrimeraVegada: $e');
    }
  }

  /// Actualitza alumnes i estructura de carpetes segons el contingut XML
  Future<List<Alumne>?> actualitzaAlumnes(
      RepositoryAlumneXml repo,
      List<Alumne> alumnesXml,
      List<Alumne> alumnesDB,
      Set<String> cursosXml,
      ) async {
    try {

      final cursosNot = ref.read(cursosNotifierProvider.notifier);

      // Prepara cursos nous i existents
      final cursosNous = cursosXml.map((nom) => Curs(nom: nom)).toList();
      final cursosActuals = await ref.read(cursosNotifierProvider.notifier).getCursosSenseModificarState();

      final nomsActuals = cursosActuals.map((c) => c.nom).toSet();
      final cursosPerAfegir = cursosNous.where((nou) => !nomsActuals.contains(nou.nom)).toList();

      final nomsNous = cursosNous.map((c) => c.nom).toSet();
      final cursosPerEsborrar = cursosActuals.where((actual) => !nomsNous.contains(actual.nom)).toList();

      //Esborrem i inserim
      await cursosNot.eliminarCursos(cursosPerEsborrar);
      final nomsCursosABorrar = cursosPerEsborrar.map((c) => c.nom).toSet();
      //Encara no esborrem els cursos pq necessitem passar les fotos

      await cursosNot.inserirCursos(cursosPerAfegir);
      final nomsNousCursos = cursosPerAfegir.map((c) => c.nom).toSet();
      //Ací creariem els directoris nous
      await storage.creaEstructuraAlumnes(nomsNousCursos);

      // Torna a carregar cursos actualitzats
      final cursosActualitzats = await ref.read(cursosNotifierProvider.notifier).getCursosSenseModificarState();
      // Alumnes a inserir o editar
      final alumneNot = await ref.read(alumnesNotifierProvider.notifier);
      final alumnesDBMap = {for (final a in alumnesDB) a.nia: a};
      final alumnesAInserir = <Alumne>[];
      final alumnesAEditar = <Alumne>[];
      final alumnesNiesXml = alumnesXml.map((a) => a.nia).toSet();

      final alumnesXmlAmbId = await repo.assignaIdCursAlsAlumnes(alumnesXml, cursosActualitzats);
      List<CanviDeCursAlumne> alumnesACanviar = [];

      // Recorre alumnes per veure si cal inserir, editar o canviar curs
      for (final alum in alumnesXmlAmbId) {
        final existent = alumnesDBMap[alum.nia];
        if (existent == null) {
          alumnesAInserir.add(alum);
        } else if ((existent.cursId != alum.cursId )) {

          var alumneAmbCursCanviat;
          alumneAmbCursCanviat = alum.copyWith(id: existent.id);

          if(existent.fotoPath != null){
            alumnesACanviar.add(CanviDeCursAlumne(cursVell: existent.grup!, cursNou: alum.grup!, niaAlumne: existent.nia));
            //final novaFotoPath = await storage.getPathAlumne(alum.grup!, existent.nom);
            final novaFotoPath = await storage.getPathAlumne(alum.grup!, existent.nia);

            alumneAmbCursCanviat = alum.copyWith(id: existent.id, fotoPath: novaFotoPath, fotoPathHash: existent.fotoPath);
          }
          alumnesAEditar.add(alumneAmbCursCanviat);
        }
      }
      // Elimina alumnes que ja no existeixen al XML
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

      // Mou les fotos d’alumnes que han canviat de curs
      await Future.wait(alumnesACanviar.map((alumne) {
        return storage.mouFotoAlumne(
          alumne.cursVell,
          alumne.cursNou,
          alumne.niaAlumne,
        );
      }));

      // Esborra carpetes que ja no són necessàries
      await storage.eliminaCarpetesAlumnes(nomsCursosABorrar);

      return alumnesAInserir;

    } catch (e, st) {
      debugPrint('Error a _actualitzaAlumnes: $e\n$st');
      return null;
    }
  }
}
