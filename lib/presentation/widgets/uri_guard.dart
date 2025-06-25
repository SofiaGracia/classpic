import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
              builder: (_) => AlertDialog(
                title: const Text('Directori no configurat'),
                content: const Text(
                  'Has de seleccionar una carpeta per a guardar les fotos.',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel·lar'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // 🔑 Navega a la pantalla de configuració:
                      Navigator.pushNamed(context, '/config');
                    },
                    child: const Text('Configurar'),
                  ),
                ],
              ),
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
