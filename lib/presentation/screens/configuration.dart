import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xml_fotos/presentation/widgets/import_button.dart';

import '../../application/services/storage_service.dart';

class ConfigurationScreen extends ConsumerStatefulWidget {
  final DirectoriFotos seleccio;

  const ConfigurationScreen({super.key, required this.seleccio});

  @override
  ConsumerState<ConfigurationScreen> createState() =>
      _ConfigurationScreenState();
}

/// Pantalla amb opcions per importar dades d'alumnes o professors.
class _ConfigurationScreenState extends ConsumerState<ConfigurationScreen> {
  late DirectoriFotos seleccioActual;

  @override
  void initState() {
    super.initState();
    seleccioActual = widget.seleccio;
  }

  @override
  Widget build(BuildContext context) {
    final storage = ref.read(StorageServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Menú',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: Expanded(
        //Hi ha que sustituir-ho per un scrollable de algo
        child: Center(
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
                const SizedBox(height: 16),
                RadioListTile(
                  title: Text('Carpeta interna de l\'aplicació'),
                  value: DirectoriFotos.intern,
                  groupValue: seleccioActual,
                  onChanged: (value) async {
                    setState(() => seleccioActual = value!);
                    await storage.guardaDirectoriSeleccionat(value!);
                  },
                ),
                RadioListTile(
                  title: Text('Pictures/ClassPic'),
                  value: DirectoriFotos.pictures,
                  groupValue: seleccioActual,
                  onChanged: (value) async {
                    setState(() => seleccioActual = value!);
                    await storage.guardaDirectoriSeleccionat(value!);
                  },
                ),
                RadioListTile(
                  title: Text('DCIM/ClassPic'),
                  value: DirectoriFotos.dcim,
                  groupValue: seleccioActual,
                  onChanged: (value) async {
                    setState(() => seleccioActual = value!);
                    await storage.guardaDirectoriSeleccionat(value!);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
