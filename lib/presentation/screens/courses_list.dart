import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xml_fotos/application/services/storage_service.dart';
import 'package:xml_fotos/presentation/providers/cursos_notifier.dart';

import '../../domain/entities/course.dart';
import '../providers/course/courses_ids_async.dart';
import '../widgets/curs.dart';
import '../widgets/new_curs_riverpod.dart';

class ListCoursesScreen extends ConsumerWidget {
  Future<List<Course>> _carregaLlista(WidgetRef ref) {
    return ref.read(courseRepositoryProvider).carregarCursosDB();
  }

  Widget _buildScaffold(WidgetRef? ref, Widget fill) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Llistat de cursos'),
      ),
      body: fill,
      floatingActionButton: NewCursR(
        provider: cursosNotifierProvider,
        onCreate: (c) async {
          await ref?.read(coursesIdsProvider.notifier).addCourse(c);
          //Si volem crear la carpeta del curs haurem de triar una carpeta d'emmagatzematge extern
          //List<Course> coursesList = [];
          //coursesList.add(c);
          //final storage = ref?.read(StorageServiceProvider);
          //await storage?.createCourseDir(coursesList);
        },
      ),
    );
  }

  Widget _buildLlista(BuildContext context, WidgetRef ref, List<Course> llista) {
    return llista.isEmpty
        ? Text('No hi ha cursos')
        : ListView(
      children: llista.map((course) {
        return CursWidget(
          cursPassat: course,
          onDelete: (c) async {
            await ref.read(coursesIdsProvider.notifier).removeCourse(course);
            List<String> courseNames = [];
            courseNames.add(c.name);
            await ref.read(StorageServiceProvider).esborraDirIContingut(courseNames);
          },
        );
      }).toList(),
    );
  }

  Widget _buildLlistaAmbStream({
    required AsyncValue<List<int>> idsAsync,
    required Future<List<Course>> Function() futureLlista,
    required WidgetRef ref,
  }) {
    return idsAsync.when(
      data: (_) =>
          FutureBuilder<List<Course>>(
            future: futureLlista(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return _buildScaffold(
                    ref, const Center(child: CircularProgressIndicator()));
              }
              return _buildScaffold(
                  ref, _buildLlista(context, ref, snapshot.data!));
            },
          ),
      error: (e, _) => _buildScaffold(null, Text('Error: $e')),
      loading: () =>
          _buildScaffold(ref, const Center(child: CircularProgressIndicator())),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coursesAsync = ref.watch(coursesIdsProvider);
    return _buildLlistaAmbStream(idsAsync: coursesAsync, futureLlista: () => _carregaLlista(ref), ref: ref);
  }
}
