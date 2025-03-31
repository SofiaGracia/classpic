import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/alumne.dart';
import '../../utils/camera.dart';
import '../../utils/carpeta.dart';

class CustomButtom extends StatelessWidget {

  final Alumne alumne;

  const CustomButtom({super.key, required this.alumne});

  Future<void> crearIEscriureArxiu() async {

    String grup = alumne.grup;
    String? path = GestorCarpetes.obtenirPathCarpeta(grup);

    String fitxerPath = '$path/${alumne.nom}_${alumne.nia}.txt';
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
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CameraPage(alumne: alumne,),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(
        'Foto',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
    );
  }
}
