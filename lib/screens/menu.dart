import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xml_fotos/repository/usuaris.dart';
import 'package:xml_fotos/screens/configuration.dart';
import 'package:xml_fotos/screens/widgets/status_button.dart';

import '../models/alumne.dart';
import '../models/professor.dart';
import '../providers/usuaris.dart';
import 'llista_usuaris.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {

  bool _carregant = true;
  bool _error = false;

  @override
  void initState() {
    super.initState();
    _comprovaDades();
  }


  void _comprovaDades() async {
    try {
      final usuarisProvider = Provider.of<UsuarisProvider>(context, listen: false);

      if (usuarisProvider.alumnes.isNotEmpty && usuarisProvider.professors.isNotEmpty) {
        setState(() {
          _carregant = false;
        });
        return;
      }

      final db = UsuarisRepository();
      final dades = await db.carregaUsuaris();

      final alumnes = dades['alumnes'] as List<Alumne>;
      final professors = dades['professors'] as List<Professor>;

      usuarisProvider.setAlumnes(alumnes);
      usuarisProvider.setProfessors(professors);

      setState(() {
        _carregant = false;
      });
    } catch (e) {
      debugPrint('Error carregant dades: $e');
      setState(() {
        _carregant = false;
        _error = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    if (_carregant) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error) {
      return const Scaffold(
        body: Center(child: Text("Error carregant la base de dades.")),
      );
    }

    final usuarisProvider = Provider.of<UsuarisProvider>(context);
    final alumnes = usuarisProvider.alumnes;
    final professors = usuarisProvider.professors;

    final llistaAlumesCarregada = alumnes.isNotEmpty;
    final llistaProfesCarregada = professors.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Menú',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Què vols fer?',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              StatusButton(
                text: 'Alumnes',
                carregat: llistaAlumesCarregada,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LlistaUsuaris(tipus: 'alumnes',),
                    ),
                  );
                },
              ),
              StatusButton(
                text: 'Professors',
                carregat: llistaProfesCarregada,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LlistaUsuaris(tipus: 'professors'),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ConfigurationScreen(),
                    ),
                  );
                },
                child: const Text('Configuració'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
