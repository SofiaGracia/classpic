/*import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xml_fotos/screens/widgets/usuari.dart';
import '../providers/usuaris.dart';
import 'data.dart';

class AlumnesDelCursScreen extends StatelessWidget {
  final String curs;

  const AlumnesDelCursScreen({super.key, required this.curs});

  @override
  Widget build(BuildContext context) {
    final usuarisProvider = Provider.of<UsuarisProvider>(context);
    final alumnes = usuarisProvider.alumnesPerCurs(curs);

    return Scaffold(
      appBar: AppBar(
        title: Text('Alumnes de $curs'),
      ),
      body: alumnes.isEmpty
          ? const Center(child: Text('No hi ha alumnes en aquest curs.'))
          : ListView.builder(
        itemCount: alumnes.length,
        itemBuilder: (context, index) {
          final usuari = alumnes[index];
          return UsuariTile(
              primerCognom: usuari.c1,
              segonCognom: usuari.c2??'',
              nom: usuari.nom,
              identificador: usuari.nia,
              onEditar: () async {
                final resultat = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DataScreen(
                      usuari: usuari, // pot ser Alumne o Professor
                      isAlumne: true,
                    ),
                  ),
                );

                if (resultat != null) {
                  // Si tornes l'usuari modificat des de DataScreen
                  usuarisProvider.editarUsuari(resultat);
                }
              },
              onEliminar:  () => usuarisProvider.eliminarUsuari(usuari)
          );
        },
      ),
      //Ací vull posar un CreateButton
    );
  }
}
*/