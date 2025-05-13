import 'package:xml_fotos/domain/entities/professor.dart';
import 'package:xml_fotos/domain/models/usuari.dart';

import '../../application/services/storage_service.dart';
import '../entities/alumne.dart';

extension FotoPathCacheExt on Usuari {
  String _generateFotoPathHash() {
    if (this is Alumne) {
      final alumne = this as Alumne;
      return '${alumne.grup}_${alumne.nom}';
    } else if (this is Professor) {
      return 'prof_${this.nom}';
    }
    throw Exception('Tipus d\'usuari no suportat');
  }

  Future<void> setFotoPathIfNeeded(StorageService storage) async {
    final nouHash = _generateFotoPathHash();
    if (fotoPath == null || fotoPathHash != nouHash) {
      if (this is Alumne) {
        final alumne = this as Alumne;
        if (alumne.grup == null) {
          throw Exception('El grup de l\'alumne no està definit');
        }
        fotoPath = await storage.getPathAlumne(alumne.grup!, alumne.nom);
      } else if (this is Professor) {
        fotoPath = await storage.getPathProfessor(nom);
      }
      // Actualitza el hash amb el nou valor generat
      fotoPathHash = nouHash;
    }
  }

  String? get fotoPathOrNull => fotoPath;
}

