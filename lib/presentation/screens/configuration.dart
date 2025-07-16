import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xml_fotos/presentation/widgets/image_configuration.dart';
import 'package:xml_fotos/presentation/widgets/import_button.dart';
import 'package:xml_fotos/presentation/widgets/radio_storage.dart';
import 'package:xml_fotos/presentation/widgets/uri_widget.dart';

import '../../application/services/storage_service.dart';
import 'manage_broken_images.dart';

class ConfigurationScreen extends ConsumerStatefulWidget {

  const ConfigurationScreen({super.key});

  @override
  ConsumerState<ConfigurationScreen> createState() =>
      _ConfigurationScreenState();
}

/// Screen with options to import students or teachers
class _ConfigurationScreenState extends ConsumerState<ConfigurationScreen> {

  @override
  void initState() {
    super.initState();
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
                //Student's ImportButton
                ImportButton(isAlumne: true),
                const SizedBox(height: 16),
                //Teacher's ImportButton
                ImportButton(isAlumne: false),
                const SizedBox(height: 16),
                const SizedBox(height: 16),
                ImageConfigurationWidget(),
                UriWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
