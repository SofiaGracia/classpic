// lib/screens/cicles.dart
/*import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../repository/interfaces/ixml.dart';

class CiclesScreen extends StatelessWidget {
  const CiclesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = context.read<IRepositoryXml>();

    return Scaffold(
      appBar: AppBar(title: const Text('Selecciona un cicle')),
      body: FutureBuilder<List<dynamic>>(
        future: repo.carregaInfo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No s’han trobat cicles.'));
          }

          final cursos = snapshot.data!;
          return ListView.builder(
            itemCount: cursos.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(cursos[index]),
              );
            },
          );
        },
      ),
    );
  }
}
*/