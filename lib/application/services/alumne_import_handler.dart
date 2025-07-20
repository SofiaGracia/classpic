import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xml/xml.dart';
import 'package:xml_fotos/application/services/dir_structure.dart';
import 'package:xml_fotos/application/services/saf_methods.dart';
import 'package:xml_fotos/application/services/storage_service.dart';
import 'package:xml_fotos/presentation/providers/student/repository.dart';
import 'package:xml_fotos/presentation/providers/student/student_ids_async.dart';
import 'package:xml_fotos/shared/utils/constants.dart';

import '../../domain/entities/student.dart';
import '../../domain/entities/course.dart';
import '../../presentation/providers/cursos_notifier.dart';
import '../../data/datasources/xml/alumne_xml.dart';
import '../../presentation/providers/uri_notifier.dart';
import '../../shared/utils/change_group.dart';


/// Classe encarregada de gestionar la importació d'alumnes a partir d'un fitxer XML
class AlumneImportHandler {
  final Ref ref;
  final StorageService storage;

  /// Constructor que rep una referència de Riverpod i el servei d'emmagatzematge
  AlumneImportHandler(this.ref, this.storage);

  /// Funció principal que processa el document XML
  Future<void> processa(XmlDocument doc) async {
    final alumneNot = ref.read(studentIdsProvider(null).notifier);

    // Obté els alumnes de la base de dades sense modificar l'estat del provider
    final alumnesDB = await ref.read(studentRepositoryProvider).findAllStudents();

    // Crea el repositori per llegir els alumnes del fitxer XML
    final repo = RepositoryAlumneXml(doc: doc);
    final parsed = repo.parseAlumnesFromXml(doc);

    final alumnesXml = parsed['alumnes'] as List<Student>;
    final cursosXml = parsed['cursos'] as Set<String>;

    if (alumnesDB.isEmpty) {

      // Si no hi ha alumnes a la base de dades, és la primera importació
      final alumnes = await _importaPrimeraVegada(repo, alumnesXml, cursosXml);
      //await alumneNot.inserirAlumnes(alumnes);
      await alumneNot.addStudents(alumnes);
    } else {

      // Si ja hi ha alumnes, es fa una actualització
      final alumnes = await actualitzaAlumnes(repo, alumnesXml, alumnesDB, cursosXml);
      if (alumnes != null) await alumneNot.addStudents(alumnes);
    }
  }

  /// Importació inicial: crea cursos, carpetes i assigna alumnes
  Future<List<Student>> _importaPrimeraVegada(
      RepositoryAlumneXml repo,
      List<Student> alumnesXml,
      Set<String> cursosXml,
      ) async {
    try{
      final cursosNot = ref.read(cursosNotifierProvider.notifier);

      // Buida els cursos existents
      await cursosNot.buidarCursos();

      // Crea l'estructura de carpetes per als cursos nous
      //await storage.creaEstructuraAlumnes(cursosXml);
      final baseDir = await ref.read(StorageServiceProvider).getBaseDirectory();
      await DirStrucService.creaEstructuraAlumnes(cursosXml);

      // Insereix els cursos a la base de dades
      final cursos = cursosXml.map((nom) => Course(name: nom)).toList();
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
  Future<List<Student>?> actualitzaAlumnes(
      RepositoryAlumneXml repo,
      List<Student> alumnesXml,
      List<Student> alumnesDB,
      Set<String> cursosXml,
      ) async {
    try {

      final cursosNot = ref.read(cursosNotifierProvider.notifier);

      // Prepara cursos nous i existents
      final cursosNous = cursosXml.map((nom) => Course(name: nom)).toList();
      final cursosActuals = await ref.read(cursosNotifierProvider.notifier).getCursosSenseModificarState();

      final nomsActuals = cursosActuals.map((c) => c.name).toSet();
      final cursosPerAfegir = cursosNous.where((nou) => !nomsActuals.contains(nou.name)).toList();

      final nomsNous = cursosNous.map((c) => c.name).toSet();
      final cursosPerEsborrar = cursosActuals.where((actual) => !nomsNous.contains(actual.name)).toList();

      //Esborrem i inserim
      await cursosNot.eliminarCursos(cursosPerEsborrar);
      final nomsCursosABorrar = cursosPerEsborrar.map((c) => c.name).toSet();
      //Encara no esborrem els cursos pq necessitem passar les fotos

      await cursosNot.inserirCursos(cursosPerAfegir);
      final nomsNousCursos = cursosPerAfegir.map((c) => c.name).toSet();
      //Ací creariem els directoris nous
      //await storage.creaEstructuraAlumnes(nomsNousCursos);
      await DirStrucService.creaEstructuraAlumnes(nomsNousCursos);

      // Torna a carregar cursos actualitzats
      final cursosActualitzats = await ref.read(cursosNotifierProvider.notifier).getCursosSenseModificarState();
      // Alumnes a inserir o editar
      final alumneNot = ref.read(studentIdsProvider(null).notifier);
      final alumnesDBMap = {for (final a in alumnesDB) a.nia: a};
      final alumnesAInserir = <Student>[];
      final alumnesAEditar = <Student>[];
      final alumnesNiesXml = alumnesXml.map((a) => a.nia).toSet();

      final alumnesXmlAmbId = await repo.assignaIdCursAlsAlumnes(alumnesXml, cursosActualitzats);
      List<CanviDeCursAlumne> alumnesACanviar = [];

      // Recorre alumnes per veure si cal inserir, editar o canviar curs
      for (final alum in alumnesXmlAmbId) {
        final existent = alumnesDBMap[alum.nia];
        if (existent == null) {
          alumnesAInserir.add(alum);
        } else if ((existent.courseId != alum.courseId )) {

          var alumneAmbCursCanviat;
          alumneAmbCursCanviat = alum.copyWith(id: existent.id);

          if(existent.hasFoto){
            alumneAmbCursCanviat = alum.copyWith(id: existent.id, hasFoto: existent.hasFoto);
            alumnesACanviar.add(CanviDeCursAlumne(cursVell: existent.group!, cursNou: alum.group!, niaAlumne: existent.nia));
            //alumneAmbCursCanviat = alum.copyWith(id: existent.id, fotoPathHash: existent.fotoPathHash);
          }
          alumnesAEditar.add(alumneAmbCursCanviat);
        }
      }
      // Elimina alumnes que ja no existeixen al XML
      final alumnesAEliminar = alumnesDB.where((a) => !alumnesNiesXml.contains(a.nia)).toList();

      if (alumnesAEliminar.isNotEmpty){

        List<Uri> fotoPaths = [];
        for(final a in alumnesAEliminar){
          final uriFotoAlumne = await PlatformChannel.getFotoAlumneUri( a.group!, a.nia);

          if(uriFotoAlumne != null){
            fotoPaths.add(uriFotoAlumne);
          }
        }

        //Eliminar les fotos dels alumnes
        //Eliminar alumnes
        await storage.eliminaFotos(fotoPaths);
        await alumneNot.removeStudents(alumnesAEliminar);
      }

      if (alumnesAEditar.isNotEmpty) await alumneNot.updateStudents(alumnesAEditar);

      // Mou les fotos d’alumnes que han canviat de curs
      await Future.wait(alumnesACanviar.map((alumne) {
        return storage.mouFotoAlumne(
          alumne.cursVell,
          alumne.cursNou,
          alumne.niaAlumne,
        );
      }));

      // Esborra carpetes que ja no són necessàries
      //await storage.eliminaCarpetesAlumnes(nomsCursosABorrar);
      final llistaNomsCursosABorrar = nomsCursosABorrar.toList();
      await storage.esborraDirIContingut(llistaNomsCursosABorrar);

      return alumnesAInserir;

    } catch (e, st) {
      debugPrint('Error a _actualitzaAlumnes: $e\n$st');
      return null;
    }
  }
}
