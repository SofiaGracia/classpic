import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xml_fotos/providers/alumne_notifier.dart';
import 'package:xml_fotos/providers/professor_notifier.dart';
import 'package:xml_fotos/screens/cursos_riverpod.dart';
import 'package:xml_fotos/screens/widgets/status_button_riverpod.dart';

import '../models/professor.dart';
import 'configuration.dart';
import 'llista_usuaris_riverpod.dart';

class MenuScreenR extends ConsumerStatefulWidget {
  const MenuScreenR({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MenuScreenRState();
}

class _MenuScreenRState extends ConsumerState<MenuScreenR> {

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
                'Què vols fer?',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              // Botó per a alumnes
              StatusButtonR(
                  text: 'Alumnes',
                  onPressed: () {
                    /*Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LlistaUsuarisScreen(),
                      ),
                    );*/
                    debugPrint("Anem a LlistaCursosScreen");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CursosScreen(),
                      ),
                    );
                  },
                  provider: alumnesNotifierProvider),
              // Botó per a professors
              StatusButtonR(
                  text: 'Professors',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LlistaUsuarisR<Professor>(
                          provider: professorNotifierProvider,
                          onEditar: (p) async => await ref.read(professorNotifierProvider.notifier).editarProfessor(p),
                          onBorrar: (p) async => await ref.read(professorNotifierProvider.notifier).eliminarProfessor(p),
                          onCreate: (p) async => await ref.read(professorNotifierProvider.notifier).inserirProfessor(p),
                        ),
                      ),
                    );
                    debugPrint("Anem a LlistaUsuarisScreen");
                  },
                  provider: professorNotifierProvider),
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
