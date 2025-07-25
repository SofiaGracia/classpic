import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xml_fotos/shared/utils/dialog/uri.dart';

import '../../shared/utils/constants.dart';

/// Botó amb estat que reflecteix l'estat de càrrega d'un provider.
/// Mostra un indicador, un error o un botó actiu segons les dades.
class StatusButtonR extends ConsumerWidget {
  final String text;
  final VoidCallback onPressed;
  final ProviderListenable<AsyncValue<List<int>>> Function(WidgetRef ref)
      totalBuilder;

  StatusButtonR({
    super.key,
    required this.text,
    required this.onPressed,
    required this.totalBuilder,
    //this.trailing,
  });

  Widget _buildWidget(List<int>? llista) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(text),
        style: ElevatedButton.styleFrom(
          backgroundColor: llista == null ? Colors.grey : llista.isEmpty? Colors.grey : defaultButtonColor,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncData = ref.watch(totalBuilder(ref));

    return asyncData.when(
      loading: () => const CircularProgressIndicator(),
      error: (err, _) {
        DialogHelper.mostrarSnackBar(context, 'Error carregant: $err');
        debugPrint('Error carregant: $err');
        return _buildWidget(null);
      },
      data: (llista) => _buildWidget(llista)
    );
  }
}
