import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/alumne.dart';
import '../../models/carpeta.dart';
import '../../providers/carpeta.dart';
import '../../utils/carpeta_manager.dart';

class CustomButtom extends StatelessWidget {

  final Alumne alumne;

  const CustomButtom({super.key, required this.alumne});

  //La funció en sí
  Future<void> crearIEscriureArxiu(BuildContext context) async {

    String grup = alumne.grup;
    Map <String, String> valorsCurs = CarpetaManager.obtindreValorsCurs(grup);

    String? curs = valorsCurs['cicle'];
    String? modalitat = valorsCurs['modalitat'];
    String? num = valorsCurs['num'];

    var carpetaProvider = Provider.of<CarpetaProvider>(context, listen: false);

    Carpeta? carpeta_alumne = carpetaProvider.obtenirCarpeta(curs!, modalitat!, num!);

    String path = carpeta_alumne!.path;

    String fitxerPath = '$path/${alumne.nom}.txt';
    final fitxer = File(fitxerPath);

    String contingut = 'Hola alumne ${alumne.nom}';

    try {
      // Escriu el contingut al fitxer
      await fitxer.writeAsString(contingut, mode: FileMode.writeOnly, flush: true);
      print('Fitxer creat i escrit correctament a $path');
    } catch (e) {
      print('Error al crear o escriure el fitxer: $e');
    }

  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {

        crearIEscriureArxiu(context);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(
        'Guardar fitxer',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
    );
  }
}
