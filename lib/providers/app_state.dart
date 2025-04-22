import 'package:flutter/material.dart';
import '../utils/directory.dart';
// importa els teus DAOs i models

enum AppStatus { loading, ready, empty, error }

class AppStateProvider extends ChangeNotifier { //Ací deuria ser with?
  AppStatus statusA = AppStatus.loading;
  AppStatus statusP = AppStatus.loading;

  Future<void> loadInitialData() async {
    try {
      // Aseguramos que los directorios existen
      await DirectoryUtil.ensureStructureExists(await DirectoryUtil.aDir);
      await DirectoryUtil.ensureStructureExists(await DirectoryUtil.pDir);

      // Verifiquem si els directoris contenen dades
      final aHasData = await DirectoryUtil.hasContent(await DirectoryUtil.aDir);
      final pHasData = await DirectoryUtil.hasContent(await DirectoryUtil.pDir);

      // Actualitzem el status per als directoris A i P
      statusA = aHasData ? AppStatus.ready : AppStatus.empty;
      statusP = pHasData ? AppStatus.ready : AppStatus.empty;

      // Si s'ha de carregar la informació des de la base de dades (quan hi ha dades)
      if (aHasData) {
        // Carregar dades d'alumnes aquí, per exemple
        // final cursos = await db.personDao.findAllCursos();
      }

      if (pHasData) {
        // Carregar dades de professors aquí, per exemple
        // final professors = await db.professorDao.findAllProfessors();
      }

    } catch (e) {
      print('Error carregant dades inicials: $e');
      statusA = AppStatus.error;
      statusP = AppStatus.error;
    }

    // Notificar a la UI que el procés ha finalitzat
    notifyListeners();
  }
}
