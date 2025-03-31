import 'package:flutter/material.dart';
import 'package:xml_fotos/screens/widgets/custom_buttom.dart';
import '../models/alumne.dart';
import '../repository/alumnes.dart';

class AlumnesScreen extends StatefulWidget {
  final String grup;

  const AlumnesScreen({super.key, required this.grup});

  @override
  _AlumnesScreenState createState() => _AlumnesScreenState();
}

class _AlumnesScreenState extends State<AlumnesScreen> {
  late Future<List<Alumne>> alumnesFuture;

  @override
  void initState() {
    super.initState();
    alumnesFuture = _carregarAlumnes(); // Assignem el Future al alumnesFuture
  }

  // Funció asíncrona per carregar els alumnes
  Future<List<Alumne>> _carregarAlumnes() async {
    return await RepositoryAlumnesXML.carregaAlumnesSegonsClasse(widget.grup);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.grup)),
      body: FutureBuilder<List<Alumne>>(
        future: alumnesFuture, // Utilitzem el Future assignat a alumnesFuture
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Quan està carregant, mostrem un indicador de progrés
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Si hi ha un error, mostrem un missatge d'error
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // Si no tenim dades, mostrem un missatge indicant que no hi ha alumnes
            return const Center(child: Text('No s\'han trobat alumnes'));
          }

          List<Alumne> alumnes = snapshot.data!;
          return ListView.builder(
            itemCount: alumnes.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(alumnes[index].nom),
                trailing: CustomButtom(alumne: alumnes[index]),
              );
            },
          );
        },
      ),
    );
  }
}
