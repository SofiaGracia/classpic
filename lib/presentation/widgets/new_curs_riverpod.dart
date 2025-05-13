import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/curs.dart';

class NewCursR extends ConsumerWidget {
  final AutoDisposeAsyncNotifierProvider<dynamic, List<Curs>> provider;
  //final Future<void> Function(Curs curs) onCreate;

  const NewCursR({required this.provider});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return FloatingActionButton(
      onPressed: () async {
        await ref.read(provider.notifier).inserirCurs(Curs(nom: 'Nou grup'));
      },
      child: const Icon(Icons.add),
      tooltip: 'Afegir curs',
    );
  }
}
