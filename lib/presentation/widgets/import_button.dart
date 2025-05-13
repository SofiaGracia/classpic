import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/import_controller.dart';

class ImportButton extends ConsumerWidget {
  final bool isAlumne;

  ImportButton({required this.isAlumne});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final controller = ref.watch(importControllerProvider);

    return ElevatedButton(
      onPressed: controller.isLoading
          ? null
          : () async {
        await ref.read(importControllerProvider.notifier).importaDades(isAlumne: isAlumne);
        final estat = ref.read(importControllerProvider);

        estat.whenOrNull(
          error: (e, _) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error : $e')),
              );
            });
            debugPrint('Error : $e');
          },
          data: (_) => ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Importació correcta.'))),
        );
      },
      child: controller.isLoading
          ? CircularProgressIndicator()
          : Text(isAlumne ? 'Importar Alumnes' : 'Importar Professors'),
    );
  }
}
