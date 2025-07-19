import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xml_fotos/application/services/storage_service.dart';
import 'package:xml_fotos/presentation/providers/cursos_notifier.dart';
import 'package:xml_fotos/shared/utils/constants.dart';

import '../../application/services/saf_methods.dart';
import '../../domain/entities/course.dart';
import '../../shared/utils/dialog/uri.dart';
import '../providers/course/courses_ids_async.dart';
import '../providers/course/repository.dart';
import '../providers/uri_notifier.dart';
import '../widgets/course.dart';
import '../widgets/new_curs_riverpod.dart';

class ListCoursesScreen extends ConsumerWidget {
  Future<List<Course>> _carregaLlista(WidgetRef ref) {
    return ref.read(courseRepositoryProvider).carregarCursosDB();
  }

  Widget _buildScaffold(BuildContext context, WidgetRef? ref, Widget fill) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Llistat de cursos'),
      ),
      body: fill,
      floatingActionButton: NewCursR(
        provider: cursosNotifierProvider,
        onCreate: (c) async {
          final uri = await ref?.read(UriProvider.notifier).getUri();

          if (uri == null) {
            DialogHelper.mostrarDialogUri(context, true);
            return;
          }

          //Creem el directori
          final res = await PlatformChannel.createFolder(
              uri: uri, tipusUsuari: alumnesFolder, grup: c.name);
          if (res == null || !res) {
            DialogHelper.mostrarSnackBar(context, mesErrCreateFolder);
            return;
          }

          await ref?.read(coursesIdsProvider.notifier).addCourse(c);
        },
      ),
    );
  }

  Widget _buildLlista(
      BuildContext context, WidgetRef ref, List<Course> llista) {
    return llista.isEmpty
        ? Text('No hi ha cursos')
        : ListView(
            children: llista.map((course) {
              return CourseWidget(
                coursePassed: course,
                onDelete: (c) async {
                  await ref
                      .read(coursesIdsProvider.notifier)
                      .removeCourse(course);
                  List<String> courseNames = [];
                  courseNames.add(c.name);
                  await ref
                      .read(StorageServiceProvider)
                      .esborraDirIContingut(courseNames);
                },
              );
            }).toList(),
          );
  }

  Widget _buildLlistaAmbStream({
    required BuildContext context,
    required AsyncValue<List<int>> idsAsync,
    required Future<List<Course>> Function() futureLlista,
    required WidgetRef ref,
  }) {
    return idsAsync.when(
      data: (_) => FutureBuilder<List<Course>>(
        future: futureLlista(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return _buildScaffold(
                context, ref, const Center(child: CircularProgressIndicator()));
          }
          return _buildScaffold(
              context, ref, _buildLlista(context, ref, snapshot.data!));
        },
      ),
      error: (e, _) => _buildScaffold(context, null, Text('Error: $e')),
      loading: () => _buildScaffold(
          context, ref, const Center(child: CircularProgressIndicator())),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coursesAsync = ref.watch(coursesIdsProvider);
    return _buildLlistaAmbStream(
        context: context,
        idsAsync: coursesAsync,
        futureLlista: () => _carregaLlista(ref),
        ref: ref);
  }
}
