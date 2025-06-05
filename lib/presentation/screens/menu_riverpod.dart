import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xml_fotos/presentation/providers/alumne_notifier.dart';
import 'package:xml_fotos/presentation/providers/provider_id.dart';
import 'package:xml_fotos/presentation/providers/professor_notifier.dart';
import 'package:xml_fotos/presentation/screens/llista_cursos.dart';
import 'package:xml_fotos/presentation/widgets/counter.dart';
import 'package:xml_fotos/presentation/widgets/status_button_riverpod.dart';

import '../../domain/entities/alumne.dart';
import '../../domain/entities/professor.dart';
import 'configuration.dart';
import 'llista_3.dart';
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
                'Accés a alumnes i professors',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              // Botó per a alumnes
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StatusButtonR(
                      text: 'Alumnes',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CursosScreen(),
                          ),
                        );
                      },
                      provider: alumnesNotifierProvider),
                  const SizedBox(width: 8),
                  CounterWidget<Alumne>(
                    provider: alumnesNotifierProvider,
                  ),
                ],
              ),
              // Botó per a professors
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StatusButtonR(
                      text: 'Professors',
                      onPressed: () async {

                        final llistaUsuaris = await ref
                            .read(professorNotifierProvider.notifier)//Utilitzem el read()
                            .getProfessorsSenseModificarState();

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LlistaUsuarisR<Professor>(
                              isAlumne: false,
                              cursId: null,
                              initialLlista: llistaUsuaris,
                            ),
                          ),
                        );
                      },
                      provider: professorNotifierProvider),
                  const SizedBox(width: 8),
                  CounterWidget<Professor>(
                    provider: professorNotifierProvider,
                  ),
                ],
              ),
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
