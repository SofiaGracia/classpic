import 'package:xml/xml.dart';

import '../models/alumne.dart';
import 'info_xml.dart';

class RepositoryAlumnesXML {
  static Future<dynamic> carregaAlumnesSegonsClasse(String classe) async {

    XmlDocument document = await RepositoryInfoXML.carregaXML() as XmlDocument;

    //Retornarem una llista d'alumnes
    List<Alumne> alumnes = [];

    try{

      final alumnosNode = document.findAllElements('alumnos').first;
      final students = alumnosNode.findElements('alumno');

      for (final student in students) {
        final nomStudent = student.getAttribute('nombre');
        final grupStudent = student.getAttribute('grupo');
        final niaStudent = student.getAttribute('NIA');
        if (grupStudent != null && nomStudent != null && niaStudent != null) {
          if(grupStudent == classe){
            //Comparar ací si el nom del grup es del mateix que volem posar
            alumnes.add(Alumne(nia:niaStudent,nom: nomStudent, grup: grupStudent ));
          }
        }
      }

      return alumnes;

    } catch (e) {
      print('Excepció: $e');
    }
  }
}