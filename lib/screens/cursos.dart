import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/usuaris.dart';
import 'llista_usuaris.dart';

class CursosScreen extends StatelessWidget {
  const CursosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final usuarisProvider = Provider.of<UsuarisProvider>(context);
    final cursos = usuarisProvider.cursos.toList()..sort();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecciona un curs'),
      ),
      body: cursos.isEmpty
          ? const Center(child: Text('No hi ha cursos disponibles.'))
          : ListView.builder(
        itemCount: cursos.length,
        itemBuilder: (context, index) {
          final curs = cursos[index];
          return ListTile(
            title: Text(curs!),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => LlistaUsuarisScreen(grup: curs, tipus: TipusUsuari.alumne,),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
