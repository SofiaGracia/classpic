import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xml_fotos/repository/implementations/professor.dart';
import 'package:xml_fotos/service/implementations/alumne_service.dart';

import '../providers/usuaris.dart';
import '../repository/usuaris.dart';
import '../repository/implementations/alumnes.dart';
import '../service/implementations/professor_service.dart';

class ConfigurationScreen extends StatelessWidget {
  const ConfigurationScreen({super.key});

  void _mostraSnackBar(BuildContext context, String missatge,
      {bool error = false}) {
    final snackBar = SnackBar(
      content: Text(missatge),
      backgroundColor: error ? Colors.red : null,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _importarAlumnes(BuildContext context) async {
    try {
      final dbRepo = UsuarisRepository();
      await dbRepo.connectaDB();

      final alumneDao = dbRepo.alumneDao;
      final repositoryAlumne = RepositoryAlumne();
      final alumneService = AlumneService(repositoryAlumne, alumneDao);

      final alumnesImportats = await alumneService.carregaIInsereixAlumnes();

      if (context.mounted) {
        context.read<UsuarisProvider>().setAlumnes(alumnesImportats);

        _mostraSnackBar(
            context, '${alumnesImportats.length} alumnes importats');
      }
    } catch (e) {
      _mostraSnackBar(context, 'Error: $e', error: true);
    }
  }

  void _importarProfessors(BuildContext context) async {
    try {
      final dbRepo = UsuarisRepository();
      await dbRepo.connectaDB();

      final profeDao = dbRepo.professorDao;
      final repositoryProfe = RepositoryProfessor();
      final profeService = ProfessorService(repositoryProfe, profeDao);

      final profesImportats = await profeService.carregaIInsereixProfessors();

      if (context.mounted) {
        context.read<UsuarisProvider>().setProfessors(profesImportats);

        _mostraSnackBar(
            context, '${profesImportats.length} professors importats');
      }
    } catch (e) {
      if (context.mounted) {
        _mostraSnackBar(context, 'Error: $e', error: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                'Importar dades de:',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => _importarAlumnes(context),
                child: const Text('Alumnat'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _importarProfessors(context),
                child: const Text('Professorat'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
