import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/alumne_notifier.dart';

class StatusButtonR extends ConsumerWidget {
  final String text;
  final VoidCallback onPressed;
  final AutoDisposeAsyncNotifierProvider<dynamic, dynamic> provider;
  final Widget? trailing;

  StatusButtonR({
    super.key,
    required this.text,
    required this.onPressed,
    required this.provider,
    this.trailing,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncData = ref.watch(provider);

    return asyncData.when(
      loading: () => const CircularProgressIndicator(),
      error: (err, _) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error carregant: $err')),
          );
        });
        debugPrint('Error carregant: $err');
        return ElevatedButton(
          onPressed: onPressed,
          child: Text(text),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
        );
      },
      data: (llista) => ElevatedButton(
        onPressed: onPressed,
        child: Text(text),
        style: ElevatedButton.styleFrom(
          backgroundColor: llista.isEmpty ? Colors.grey : Colors.blue,
        ),
      ),
    );
  }
}
