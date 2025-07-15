import 'package:flutter/cupertino.dart';
import 'package:xml/xml.dart';

import '../../../application/services/codi_generator.dart';
import '../../../domain/entities/teacher.dart';
import '../../../shared/utils/constants.dart';

class RepositoryProfessorXml {
  late XmlDocument doc;

  RepositoryProfessorXml({required this.doc});

  Future<List<Teacher>> carregaLlistaProfessorsXml() async {
    //Retornarem una llista de professors
    List<Teacher> llistaProfessors = [];

    try {
      final profesNode = doc.findAllElements('docentes').first;
      final profes = profesNode.findElements('docente');

      for (final prof in profes) {
        final profDni = prof.getAttribute('documento');
        final profNom = prof.getAttribute('nombre');
        final profC1 = prof.getAttribute('apellido1');
        final profC2 = prof.getAttribute('apellido2');

        if (profDni != null && profNom != null && profC1 != null) {
          final idDni = CodiGenerator.normalitzaIdentificador(profDni);

          Teacher profAInsertar = Teacher(
              dni: idDni,
              nom: profNom,
              c1: profC1,
              c2: profC2,
              fotoPathHash: DateTime.now().millisecondsSinceEpoch.toString(),
              hasFoto: false);
          llistaProfessors.add(profAInsertar);
        }
      }
    } catch (e) {
      debugPrint('Excepció: $e');
    }
    return llistaProfessors;
  }
}
