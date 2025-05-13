import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xml_fotos/presentation/widgets/import_button.dart';

/// Pantalla amb opcions per importar dades d'alumnes o professors.
class ConfigurationScreen extends StatelessWidget {
  const ConfigurationScreen({super.key});

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
              //ImportButton per a Alumnes
              ImportButton(isAlumne: true),
              const SizedBox(height: 16),
              //ImportButton per a Professors
              ImportButton(isAlumne: false),
            ],
          ),
        ),
      ),
    );
  }
}
