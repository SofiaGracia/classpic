import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:classpic/presentation/widgets/uri_dialog.dart';

import '../../shared/utils/dialog/uri.dart';
import '../providers/uri_notifier.dart';

class UriGuard extends ConsumerWidget {
  final Widget child;

  const UriGuard({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uriAsync = ref.watch(UriProvider);

    return uriAsync.when(
      data: (uri) {
        if (uri == null) {
          // Mostrar diàleg immediat
          DialogHelper.mostrarDialogUri(context, true);
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
