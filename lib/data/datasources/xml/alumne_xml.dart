import 'package:xml/xml.dart';
import 'package:classpic/application/services/codi_generator.dart';
import 'package:classpic/shared/utils/constants.dart';

import '../../../domain/entities/student.dart';
import '../../../domain/entities/course.dart';

class RepositoryAlumneXml {

  late XmlDocument doc;

  RepositoryAlumneXml({required this.doc});

  Future<List<Student>> assignaIdCursAlsAlumnes(
      List<Student> alumnes, List<Course> cursosBD) async {
    return alumnes.map((alumne) {
      final curs = cursosBD.firstWhere(
              (c) => c.name == alumne.group,
          orElse: () => throw Exception("Curs no trobat: ${alumne.group}"));
      return alumne.copyWith(cursId: curs.id);
    }).toList();
  }

  Map<String, dynamic> parseAlumnesFromXml(XmlDocument doc) {
    final alumnes = <Student>[];
    Set<String> cursosUnics = Set();
    final alumnesNode = doc.findAllElements('alumnos').first;
    for (final alu in alumnesNode.findElements('alumno')) {
      final mat = alu.getAttribute('estado_matricula');
      if (mat == Student.enrollmentStatus) {
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

          alumnes.add(Student(
            nia: idNia,
            name: aluNom,
            s1: aluC1,
            s2: aluC2,
            group: aluGrup,
              photoPathHash: DateTime.now()
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
