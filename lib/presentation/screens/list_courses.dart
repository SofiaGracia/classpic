import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xml_fotos/presentation/widgets/curs.dart';
import 'package:xml_fotos/presentation/widgets/new_curs_riverpod.dart';

import '../../application/services/storage_service.dart';
import '../../domain/entities/course.dart';
import '../providers/cursos_notifier.dart';

class CoursesScreen extends ConsumerStatefulWidget {
  const CoursesScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends ConsumerState<CoursesScreen> {
  List<Course> _cursos = [];

  @override
  void initState() {
    super.initState();
    _loadLlista();
  }

  Future<void> _loadLlista() async {
    final cursos = await ref
        .read(cursosNotifierProvider.notifier)
        .getCursosSenseModificarState();
    setState(() {
      _cursos = cursos;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cursos'),
      ),
      body: ListView.builder(
        itemCount: _cursos.length,
        itemBuilder: (context, index) {
          final cursSencer = _cursos[index];
          return CursWidget(
            cursPassat: cursSencer,
            onDelete: (c) async {
              await ref.read(cursosNotifierProvider.notifier).eliminarCurs(c);
              final storage = ref.read(StorageServiceProvider);
              //await storage.eliminarFotosCarpetaCurs(c.nom);
              await _loadLlista();
            },
          );
        },
      ),
      floatingActionButton: NewCursR(
        provider: cursosNotifierProvider,
        onCreate: (c) async {
          await ref.read(cursosNotifierProvider.notifier).inserirCurs(c);
          final storage = ref.read(StorageServiceProvider);
          //await storage.creaCarpetaGrup(c.nom);
          //Sustituir el setState() per un await _loadLlista()
          setState(() {
            _loadLlista();
          });
        },
      ),
    );
  }
}
