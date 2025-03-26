import 'package:xml/xml.dart';
import 'package:xml_fotos/repository/info_xml.dart';
import 'package:xml_fotos/utils/carpeta_manager.dart';

import '../models/grup.dart';

class RepositoryCursosXML {
  static Future<dynamic> carregaInfo() async {

    XmlDocument document = await RepositoryInfoXML.carregaXML() as XmlDocument;

    Map<String, Map<String, Set<Grup>>> cursos = {};

    void _afegirCurs(String tipus, String modalitat, Grup grup) {
      cursos.putIfAbsent(tipus, () => {});
      cursos[tipus]!.putIfAbsent(modalitat, () => {});
      cursos[tipus]![modalitat]!.add(grup);
    }

    try {
      final alumnosNode = document.findAllElements('alumnos').first;
      final students = alumnosNode.findElements('alumno');

      final grupsSet = <String>{};

      for (final student in students) {
        final grupStudent = student.getAttribute('grupo');
        if (grupStudent != null) {
          grupsSet.add(grupStudent.trim());
        }
      }

      for (var cicle_grup in grupsSet) {
        if (cicle_grup.isNotEmpty) {
          bool contePunt = cicle_grup.contains('.');
          Map <String, String> valorsCurs = CarpetaManager.obtindreValorsCurs(cicle_grup);

          String? cicle = valorsCurs['cicle'];
          String? modalitat = valorsCurs['modalitat'];
          String? num = valorsCurs['num'];

          if (contePunt) {

            Grup grup_a_afegir = Grup.fromAlgo(num!, cicle_grup);

            _afegirCurs(cicle!, modalitat!, grup_a_afegir);
          } else {

            final iniciCicle = cicle_grup[1];

            if (iniciCicle.toUpperCase() == 'E') {

              Grup grup_a_afegir = Grup.fromAlgo(num!, cicle_grup);
              _afegirCurs(cicle!, modalitat!, grup_a_afegir);

            } else {
              Grup grup_a_afegir = Grup.fromAlgo(num!, cicle_grup);
              _afegirCurs(cicle!, modalitat!, grup_a_afegir);
            }
          }
        }
      }

      // Ordenar els cursos alfabèticament per tipus i modalitat
      final cursosOrdenats = Map.fromEntries(
        cursos.entries.toList()
          ..sort((a, b) => a.key.compareTo(b.key)), // Ordenar per tipus
      );

      // Ordenar les modalitats i els grups dins de cada tipus
      cursosOrdenats.forEach((tipus, modalitats) {
        // Ordenar modalitats numèricament si són números
        final modalitatsOrdenades = modalitats.keys.toList()
          ..sort((a, b) {
            final numA = int.tryParse(a);
            final numB = int.tryParse(b);
            if (numA != null && numB != null) {
              return numA.compareTo(numB); // Ordenar numèricament
            }
            return a.compareTo(b); // Si no és numèric, ordenar alfabèticament
          });

        // Actualitzar les modalitats ordenades
        final modalitatsOrdenadesMap = {
          for (var modalitat in modalitatsOrdenades)
            modalitat: modalitats[modalitat]!
        };

        // Substituir les modalitats ordenades al mapa original
        cursosOrdenats[tipus] = modalitatsOrdenadesMap;

        // Ordenar els grups dins de cada modalitat
        modalitatsOrdenadesMap.forEach((modalitat, grups) {
          final grupsOrdenats = grups.toList()
            ..sort((a, b) =>
                a.toString().compareTo(b.toString())); // Ordenar per grup
          cursosOrdenats[tipus]![modalitat] = grupsOrdenats.toSet();
        });
      });

      return cursosOrdenats;

    } catch (e) {
      print('Excepció: $e');
    }

  }
}