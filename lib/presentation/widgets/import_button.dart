import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:classpic/domain/errors/import.dart';
import 'package:classpic/shared/themes/basic_theme.dart';
import '../../shared/utils/constants.dart';
import '../../shared/utils/dialog/uri.dart';
import '../providers/import_controller.dart';

class ImportButton extends ConsumerWidget {
  final bool isAlumne;

  ImportButton({required this.isAlumne});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(importControllerProvider);

    return ListTile(
      title: Text(isAlumne ? 'Importar Alumnes' : 'Importar Professors', style: getTheme(context).textTheme.bodyMedium,),
      subtitle: Text('(sols fitxers xml)', style: getTheme(context).textTheme.bodySmall),
      trailing: IconButton(icon: Icon(Icons.file_open_outlined), onPressed: controller.isLoading? null: () async {
        await ref
            .read(importControllerProvider.notifier)
            .importaDades(isAlumne: isAlumne);
        final estat = ref.read(importControllerProvider);

        estat.whenOrNull(
            error: (e, _) {
          if (e is DirectoriBaseNoTriat) {
            //return UriGuard(child: ConfigurationScreen());
            DialogHelper.mostrarDialogUri(context, false);
          } else {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(e is ImportError
                        ? e.message
                        : 'Error en la importació de dades')),
              );
            });
          }
        },
        data: (_) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Importació correcta.'))),);
      }),
    );

    return ElevatedButton(
      onPressed: controller.isLoading
          ? null
          : () async {
              await ref
                  .read(importControllerProvider.notifier)
                  .importaDades(isAlumne: isAlumne);
              final estat = ref.read(importControllerProvider);

              estat.whenOrNull(
                error: (e, _) {
                  if (e is DirectoriBaseNoTriat) {
                    //return UriGuard(child: ConfigurationScreen());
                    DialogHelper.mostrarDialogUri(context, false);
                  } else {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(e is ImportError
                                ? e.message
                                : 'Error en la importació de dades')),
                      );
                    });
                  }
                },
                data: (_) => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Importació correcta.'))),
              );
            },
      child: controller.isLoading
          ? CircularProgressIndicator()
          : Text(isAlumne ? 'Importar Alumnes' : 'Importar Professors'),
      style: getStyleElevatedButton(context, themeColor),
    );
  }
}
