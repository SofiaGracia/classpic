/*import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/usuaris.dart';
import 'llista_usuaris.dart';

class CursosScreen extends StatefulWidget {
  const CursosScreen({super.key});

  @override
  State<CursosScreen> createState() => _CursosScreenState();
}

class _CursosScreenState extends State<CursosScreen> {
  String? _nouCursEnEdicio;
  final _controller = TextEditingController();

  void _afegirNouCurs() {
    setState(() {
      _nouCursEnEdicio = ''; // Afegim un curs buit per a començar l'edició
      _controller.clear();
    });
  }

  void _guardarNouCurs(UsuarisProvider provider) {
    final nouNom = _controller.text.trim();
    if (nouNom.isNotEmpty && !provider.cursos.contains(nouNom)) {
      provider.afegirCurs(nouNom);
    }
    setState(() {
      _nouCursEnEdicio = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UsuarisProvider>(context);
    final cursos = provider.cursos.toList()..sort();

    return Scaffold(
      appBar: AppBar(title: const Text('Selecciona un curs')),

      body: ListView.builder(
        itemCount: cursos.length + (_nouCursEnEdicio != null ? 1 : 0),
        itemBuilder: (context, index) {
          if (_nouCursEnEdicio != null && index == 0) {
            return ListTile(
              title: TextField(
                controller: _controller,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Nom del nou curs',
                ),
                onSubmitted: (_) => _guardarNouCurs(provider),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.check),
                onPressed: () => _guardarNouCurs(provider),
              ),
            );
          }

          final curs = cursos[_nouCursEnEdicio != null ? index - 1 : index];
          return ListTile(
            title: Text(curs!),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => LlistaUsuarisScreen(grup: curs, tipus: TipusUsuari.alumne),
                ),
              );
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _afegirNouCurs,
        child: const Icon(Icons.add),
      ),
    );
  }
}
*/