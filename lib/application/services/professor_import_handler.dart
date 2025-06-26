import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xml/xml.dart';
import 'package:xml_fotos/application/services/storage_service.dart';

import '../../presentation/providers/professor_notifier.dart';
import '../../data/datasources/xml/professor_xml.dart';

/// Aquesta classe s'encarrega de processar i importar professors des d'un fitxer XML.
/// Utilitza Riverpod per gestionar l'estat i StorageService per gestionar les fotos.
class ProfessorImportHandler{
  final Ref ref; // Referència de Riverpod per accedir als Notifiers
  final StorageService storage; // Servei que gestiona el sistema de fitxers

  // Constructor de la classe
  ProfessorImportHandler(this.ref, this.storage);

  /// Funció principal que processa un document XML amb professors i sincronitza amb la base de dades local.
  Future<void> processa(XmlDocument doc) async {

    // Obtenim el Notifier de professors per poder modificar el seu estat
    final profNot = ref.read(professorNotifierProvider.notifier);

    // Obtenim els professors actuals de la base de dades (sense modificar el state de Riverpod)
    final professorsDB = await ref.read(professorNotifierProvider.notifier).getProfessorsSenseModificarState();

    // Parsegem el document XML per obtenir la llista de professors nous
    final professorsXml = await RepositoryProfessorXml(doc: doc).carregaLlistaProfessorsXml();

    // Si no hi ha professors a la base de dades, és la primera importació
    if (professorsDB.isEmpty) {

      // Inserim tots els professors parsejats
      await profNot.inserirProfessors(professorsXml);
    } else {

      // Si ja hi ha professors, cal comparar i sincronitzar

      // Convertim la llista de professors de la base de dades a un conjunt de DNIs
      final profDBSet = professorsDB.map((e) => e.dni).toSet();

      // Professors nous que s'han d'afegir: estan al XML però no a la base de dades
      final pAfegir = professorsXml.where((p) => !profDBSet.contains(p.dni)).toList();

      // Professors que s'han d'eliminar: estan a la base de dades però no al XML
      final pEliminar = professorsDB.where((p) => !professorsXml.any((px) => px.dni == p.dni)).toList();

      // Inserim els professors nous, si n'hi ha
      if (pAfegir.isNotEmpty) await profNot.inserirProfessors(pAfegir);

      // Eliminem professors que ja no apareixen al fitxer XML
      if (pEliminar.isNotEmpty){
        List<String> fotoPaths = [];

        // ATENCIÓ !!!! Podem tindre el cas de no tindre baseDir però sí fotoPaths a eliminar

        // Recollim els camins de les fotos dels professors a eliminar
        for(final p in pEliminar){
          if(p.fotoFilename != null){
            fotoPaths.add(p.fotoFilename!);
          }
        }

        // Eliminem les fotos del sistema de fitxers
        await storage.eliminaFotos(fotoPaths);

        // Eliminem els professors de la base de dades
        await profNot.eliminarProfessors(pEliminar);
      }
    }
  }
}