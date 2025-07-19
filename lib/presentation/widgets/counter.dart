import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/user.dart';

class CounterWidget<T extends User> extends ConsumerWidget {
  final ProviderListenable<AsyncValue<List<int>>> Function(WidgetRef ref)
      totalBuilder;
  final AutoDisposeStreamProvider<int?> withPhoto;

  const CounterWidget({
    super.key,
    required this.totalBuilder,
    required this.withPhoto,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalAsync = ref.watch(totalBuilder(ref));

    return totalAsync.when(
      data: (ids) {
        final total = ids.length;
        final ambFotoAsync = ref.watch(withPhoto);

        return ambFotoAsync.when(
          data: (ambFoto) {
            return Text(
              '$ambFoto/$total',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: ambFoto == total ? Colors.green : Colors.orange,
              ),
            );
          },
          loading: () => const CircularProgressIndicator(strokeWidth: 2),
          error: (_, __) => const Icon(Icons.error, color: Colors.red),
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
