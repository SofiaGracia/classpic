import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xml_fotos/presentation/widgets/curs.dart';
import 'package:xml_fotos/presentation/widgets/new_curs_riverpod.dart';

import '../providers/cursos_notifier.dart';

class CursosScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cursosAsync = ref.watch(cursosNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Cursos')),
      body: cursosAsync.when(
        data: (cursos) => ListView.builder(
          itemCount: cursos.length,
          itemBuilder: (context, index) {
            final curs = cursos[index];
            return CursWidget(cursId: curs.id!);
          },
        ),
        loading: () => Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
      floatingActionButton: NewCursR(provider: cursosNotifierProvider),
    );
  }
}
