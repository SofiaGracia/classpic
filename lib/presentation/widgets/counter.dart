import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/user.dart';

class CounterWidget<T extends User> extends ConsumerWidget {
  final ProviderListenable<AsyncValue<List<T>>> provider;

  const CounterWidget({
    super.key,
    required this.provider,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usuariAsync = ref.watch(provider);

    return usuariAsync.when(
      data: (usuaris) {
        final total = usuaris.length;
        final ambFoto = usuaris.where((u) => u.hasFoto == true).length;

        return Text(
          '$ambFoto/$total',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: ambFoto == total ? Colors.green : Colors.orange,
          ),
        );
      },
      loading: () => const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
      error: (e, st) => const Icon(Icons.error, color: Colors.red),
    );
  }
}
