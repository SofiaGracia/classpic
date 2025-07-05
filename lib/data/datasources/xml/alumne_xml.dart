import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xml/xml.dart';
import 'package:xml_fotos/application/services/codi_generator.dart';
import 'package:xml_fotos/data/datasources/xml/xml.dart';
import 'package:xml_fotos/shared/utils/constants.dart';

import '../../../domain/entities/alumne.dart';
import '../../../domain/entities/curs.dart';
import '../../../presentation/providers/cursos_notifier.dart';
import '../../repository/curs_db.dart';

class RepositoryAlumneXml {

  late XmlDocument doc;
  //late CursosNotifier cursosNotifier;

  //RepositoryAlumneXml({required this.doc, required this.cursosNotifier});
  RepositoryAlumneXml({required this.doc});

  //I alomillor esta funció no deuria ni estar ací i deuria estar en
  //repositoryAlumne o el provider d'Alumne
  Future<List<Alumne>> assignaIdCursAlsAlumnes(
      List<Alumne> alumnes, List<Curs> cursosBD) async {
    return alumnes.map((alumne) {
      final curs = cursosBD.firstWhere(
              (c) => c.nom == alumne.grup,
          orElse: () => throw Exception("Curs no trobat: ${alumne.grup}"));
      return alumne.copyWith(cursId: curs.id);
    }).toList();
  }

  Map<String, dynamic> parseAlumnesFromXml(XmlDocument doc) {
    final alumnes = <Alumne>[];
    Set<String> cursosUnics = Set();
    final alumnesNode = doc.findAllElements('alumnos').first;
    for (final alu in alumnesNode.findElements('alumno')) {
      final mat = alu.getAttribute('estado_matricula');
      if (mat == Alumne.estatMatriculat) {
        final aluNia = alu.getAttribute('NIA');
        final aluNom = alu.getAttribute('nombre');
        final aluC1 = alu.getAttribute('apellido1');
        final aluC2 = alu.getAttribute('apellido2');
        var aluGrup  = alu.getAttribute('grupo');
        if (aluGrup == null || (aluGrup.trim()).isEmpty){
          aluGrup = grupSensenom;
        }
        cursosUnics.add(aluGrup);

        if (aluNia != null && aluNom != null && aluC1 != null) {

          final idNia = CodiGenerator.normalitzaIdentificador(aluNia);

          alumnes.add(Alumne(
            nia: idNia,
            nom: aluNom,
            c1: aluC1,
            c2: aluC2,
            grup: aluGrup,
            fotoPathHash: DateTime.now()
                .millisecondsSinceEpoch
                .toString(),
            hasFoto: false
          ));
        }
      }
    }
    return {'alumnes':alumnes, 'cursos':cursosUnics};
  }
}
