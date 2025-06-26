import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xml_fotos/presentation/widgets/uri_dialog.dart';

import '../providers/uri_notifier.dart';

class UriGuard extends ConsumerWidget {
  final Widget child;

  const UriGuard({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uriAsync = ref.watch(uriProvider);

    return uriAsync.when(
      data: (uri) {
        if (uri == null) {
          // Mostrar diàleg immediat
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showDialog(
              context: context,
              builder: (_) => UriDialog(navigates: true)
            );
          });
          return const SizedBox(); // Mentre es mostra el diàleg
        } else {
          return child; // Tot OK: mostra el contingut normal
        }
      },
      loading: () {
        return CircularProgressIndicator();
      },
      error: (e, st) => Center(child: Text('Error: $e')),
    );
  }
}
