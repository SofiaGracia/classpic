
import 'package:xml/xml.dart';

import '../interfaces/icursos.dart';
import '../info_xml.dart';

class RepositoryCursos  implements IRepositoryCursos {
  @override
  Future<List> carregaInfo() async {
    XmlDocument document = await RepositoryInfoXML.carregaXML() as XmlDocument;

    final alumnosNode = document
        .findAllElements('alumnos')
        .first;
    final students = alumnosNode.findElements('alumno');

    final grupsSet = <String>{};

    for (final student in students) {
      var grupStudent = student.getAttribute('grupo');
      if (grupStudent != null) {
        grupStudent = grupStudent.trim();
        if(grupStudent.isNotEmpty){
          grupsSet.add(grupStudent);
        }
      }
    }

    // Convertir a llista i ordenar alfabèticament
    List<String> grupsOrdenats = grupsSet.toList()..sort();

    return grupsOrdenats;
  }
}