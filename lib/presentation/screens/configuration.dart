import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:classpic/presentation/widgets/image_configuration.dart';
import 'package:classpic/presentation/widgets/import_button.dart';
import 'package:classpic/presentation/widgets/uri_widget.dart';
import 'package:classpic/shared/themes/basic_theme.dart';

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
          'Configuració',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          Row(
            children: [
                  Text(
                    'Importar dades de:',
                    style: getTheme(context).textTheme.bodyMedium?.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
            ],
          ),
          const SizedBox(height: 16),
          //Student's ImportButton
          ImportButton(isAlumne: true),
          const SizedBox(height: 16),
          //Teacher's ImportButton
          ImportButton(isAlumne: false),
          const SizedBox(height: 15),
          Divider(
            color: Colors.grey,
            thickness: 0.5,
            //indent: 20,
            //endIndent: 20,
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Resolució de la imatge:',
                    style: getTheme(context).textTheme.bodyMedium?.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ImageConfigurationWidget(),

                ],
              )
            ],
          ),
          const SizedBox(height: 15),
          Divider(
            color: Colors.grey,
            thickness: 0.5,
            //indent: 20,
            //endIndent: 20,
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Seleccionar carpeta:',
                    style: getTheme(context).textTheme.bodyMedium?.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ],
              )
            ],
          ),
          const SizedBox(height: 16),
          UriWidget()
        ],
      )
    );
  }
}
