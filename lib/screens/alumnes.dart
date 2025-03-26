import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xml_fotos/screens/widgets/custom_buttom.dart';
import '../models/alumne.dart';
import '../models/grup.dart';
import '../repository/alumnes.dart';

class AlumnesScreen extends StatefulWidget {
  final Grup grup;

  const AlumnesScreen({super.key, required this.grup});

  @override
  _AlumnesScreenState createState() => _AlumnesScreenState();
}

class _AlumnesScreenState extends State<AlumnesScreen> {
  late Future<List<Alumne>> alumnesFuture; // Corregit tipus de la variable

  @override
  void initState() {
    super.initState();
    // Cridem la funció asíncrona en initState
    alumnesFuture = obtindreAlumnesClasse(); // Assignem el futur aquí
  }

  // La funció que carrega els alumnes
  Future<List<Alumne>> obtindreAlumnesClasse() async {
    return await RepositoryAlumnesXML.carregaAlumnesSegonsClasse(widget.grup.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.grup.nom_complet)),
      body: FutureBuilder<List<Alumne>>(
        future: alumnesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Quan està carregant, mostrem un indicador de progrés
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Si hi ha un error, mostrem un missatge d'error
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            // Si tenim dades, les mostrem en una llista
            List<Alumne> alumnes = snapshot.data!;
            return ListView.builder(
              itemCount: alumnes.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(alumnes[index].nom),
                  trailing: CustomButtom(alumne:alumnes[index]),
                );
              },
            );
          } else {
            // Si no tenim dades, mostrem un missatge indicant que no hi ha alumnes
            return Center(child: Text('No s\'han trobat alumnes'));
          }
        },
      ),
    );
  }
}
