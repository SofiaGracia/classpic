import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/uri_notifier.dart';

class UriWidget extends ConsumerStatefulWidget {
  const UriWidget({super.key});

  @override
  ConsumerState<UriWidget> createState() => _UriWidgetState();
}

class _UriWidgetState extends ConsumerState<UriWidget>{

  Widget mostrarUriWidget(String? uri){
    return ListTile(
      title: Text('Carpeta seleccionada'),
      subtitle: Text(uri ?? 'Cap carpeta seleccionada'),
      trailing: IconButton(
        icon: Icon(Icons.folder_open),
        tooltip: 'Canviar carpeta',
        onPressed: () {
          ref.read(uriProvider.notifier).updateUri();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final uriAsync = ref.watch(uriProvider);

    return uriAsync.when(
      data: (uri) {
        return mostrarUriWidget(uri);
      },
      loading: () => const CircularProgressIndicator(),
      error: (error, stack) {
        return mostrarUriWidget(null);
      },
    );
  }
}
