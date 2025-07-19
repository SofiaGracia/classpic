import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xml_fotos/domain/models/user.dart';
import 'package:xml_fotos/presentation/providers/professor_notifier.dart';
import 'package:xml_fotos/presentation/providers/student/stream.dart';

import '../../application/services/saf_methods.dart';
import '../../application/services/storage_service.dart';
import '../../domain/entities/student.dart';
import '../../domain/entities/course.dart';
import '../../domain/entities/teacher.dart';
import '../providers/alumne_notifier.dart';
import '../providers/student/student_ids_async.dart';
import '../providers/teacher/stream.dart';
import '../providers/teacher/teachers_ids_async.dart';
import '../widgets/new_user.dart';
import '../widgets/user_card.dart';

class UsersListScreen<T extends User> extends ConsumerWidget {
  final Course? curs;

  const UsersListScreen({super.key, required this.curs});

  String _getTitol() {
    return curs != null ? 'Alumnes de ${curs!.name}' : 'Professors';
  }

  Future<List<T>> _carregaLlista<T extends User>(WidgetRef ref, int? cursId) {
    if (cursId != null) {
      return ref
          .read(alumnesNotifierProvider.notifier)
          .getAlumnesPerCurs(cursId) as Future<List<T>>;
    } else {
      return ref
          .read(professorNotifierProvider.notifier)
          .getProfessorsSenseModificarState() as Future<List<T>>;
    }
  }

  Widget _buildScaffold(WidgetRef? ref, Widget fill) {
    return Scaffold(
      appBar: AppBar(
        title: Text((_getTitol())),
      ),
      body: fill,
      floatingActionButton: ref == null
          ? null
          : NewUserR<User>(
        onCreate: (u) async {
          if (u is Student) {
            await ref.read(studentIdsProvider(curs!.id!).notifier).addStudent(u);
          } else {
            await ref.read(asyncTeacherIdsProvider.notifier).addTeacher(u as Teacher);
          }
        },
        cursId: curs != null ? curs?.id : null,
        getId: (u) =>
        curs != null ? (u as Student).nia : (u as Teacher).dni,
        isAlumne: curs != null,
      ),
    );
  }

  Widget _buildLlista(BuildContext context, WidgetRef ref, List<T> llista) {
    return llista.isEmpty
        ? Text('No hi ha usuaris')
        : ListView(
      children: llista.map((usuari) {
        return UserCard(
          usuari: usuari,
          onDelete: (u) async {
            Uri? uriToDelete;

            if (u is Student) {
              await ref.read(studentIdsProvider(curs!.id!).notifier).removeStudent(u);

              if (u.hasFoto) {
                final uriAlumne = await PlatformChannel.getFotoAlumneUri(
                    u.group!, u.nia);

                uriToDelete = uriAlumne;
              }
            } else {
              await ref.read(asyncTeacherIdsProvider.notifier).removeTeacher(u as Teacher);
              if (u.hasFoto) {
                final uriProf =
                await PlatformChannel.getFotoProfessorUri(u.dni);

                uriToDelete = uriProf;
              }

              if (uriToDelete != null) {
                await ref
                    .read(StorageServiceProvider)
                    .eliminaFoto(uriToDelete);
              }
            }
          },
        );
      }).toList(),
    );
  }

  Widget _buildLlistaAmbStream({
    required AsyncValue<List<int>> idsAsync,
    required Future<List<T>> Function() futureLlista,
    required WidgetRef ref,
  }) {
    return idsAsync.when(
      data: (_) => FutureBuilder<List<T>>(
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
    return curs != null
        ? _buildLlistaAmbStream(
      idsAsync: ref.watch(studentIdsProvider(curs!.id!)),
      futureLlista: () => _carregaLlista(ref, curs!.id),
      ref: ref,
    )
        : _buildLlistaAmbStream(
      idsAsync: ref.watch(asyncTeacherIdsProvider),
      futureLlista: () => _carregaLlista(ref, null),
      ref: ref,
    );
  }
}
