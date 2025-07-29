import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:classpic/presentation/providers/student/stream.dart';

import '../../application/services/saf_methods.dart';
import '../../application/services/storage_service.dart';
import '../../domain/entities/course.dart';
import '../../domain/entities/student.dart';
import '../../domain/entities/teacher.dart';
import '../../domain/models/user.dart';
import '../providers/student/repository.dart';
import '../providers/student/student_ids_async.dart';
import '../providers/teacher/repository.dart';
import '../providers/teacher/stream.dart';
import '../providers/teacher/teachers_ids_async.dart';
import '../widgets/new_user.dart';
import '../widgets/search_widget.dart';
import '../widgets/user_card.dart';

class UsersListScreen<T extends User> extends ConsumerStatefulWidget {
  final Course? course;

  const UsersListScreen({super.key, required this.course});

  @override
  UsersListScreenState createState() => UsersListScreenState();
}

class UsersListScreenState<T extends User>
    extends ConsumerState<UsersListScreen> {
  String valueSearched = '';
  late Course? course;

  @override
  void initState() {
    super.initState();
    course = widget.course;
  }

  String _getTitol() {
    return course != null ? 'Alumnes de ${course!.name}' : 'Professors';
  }

  Future<List<T>> _carregaLlista<T extends User>(WidgetRef ref, int? courseId) {
    if (courseId != null) {
      return ref.read(studentRepositoryProvider).getStudentsByCurs(courseId)
          as Future<List<T>>;
    } else {
      return ref.read(teacherRepositoryProvider).carregaProfessorsDB()
          as Future<List<T>>;
    }
  }

  Widget _buildScaffold(WidgetRef? ref, Widget fill) {
    return Scaffold(
      appBar: AppBar(
        title: Text((_getTitol())),
      ),
      body: Column(
        children: [
          SearchWidget(
            value: valueSearched,
            onValueSearched: (value) {
              setState(() {
                valueSearched = value;
              });
            },
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(child: fill)
        ],
      ),
      floatingActionButton: ref == null
          ? null
          : NewUserR<User>(
              onCreate: (u) async {
                if (u is Student) {
                  await ref
                      .read(studentIdsProvider(course!.id!).notifier)
                      .addStudent(u);
                  ref.invalidate(studentIdsProvider(null));
                } else {
                  await ref
                      .read(asyncTeacherIdsProvider.notifier)
                      .addTeacher(u as Teacher);
                }
              },
              cursId: course != null ? course?.id : null,
              getId: (u) =>
                  course != null ? (u as Student).nia : (u as Teacher).dni,
              isAlumne: course != null,
            ),
    );
  }

  Widget _buildLlista(BuildContext context, WidgetRef ref, List<T> llista) {
    return llista.isEmpty
        ? Text('No hi ha usuaris')
        : ListView.builder(
            itemCount: llista.length,
            itemBuilder: (context, index) {
              final usuari = llista[index];
              return UserCard(
                usuari: usuari,
                onDelete: (u) async {
                  Uri? uriToDelete;

                  if (u is Student) {
                    await ref
                        .read(studentIdsProvider(course!.id!).notifier)
                        .removeStudent(u);

                    if (u.hasFoto) {
                      final uriAlumne = await PlatformChannel.getFotoAlumneUri(
                          u.group!, u.nia);

                      uriToDelete = uriAlumne;
                    }
                  } else {
                    await ref
                        .read(asyncTeacherIdsProvider.notifier)
                        .removeTeacher(u as Teacher);
                    if (u.hasFoto) {
                      final uriProf =
                          await PlatformChannel.getFotoProfessorUri(u.dni);

                      uriToDelete = uriProf;
                    }
                  }
                  if (uriToDelete != null) {
                    await ref
                        .read(StorageServiceProvider)
                        .eliminaFoto(uriToDelete);
                  }
                  ref.invalidate(studentIdsProvider(null));
                },
              );
            });
  }

  Widget _buildLlistaAmbNotifier({
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

  Widget _buildLlistaTeacherAmbStream(
      {required AsyncValue<List<Teacher>> usersAsync, required WidgetRef ref}) {
    return usersAsync.when(
      data: (users) {
        return _buildScaffold(ref, _buildLlista(context, ref, users as List<T>));
      },
      error: (e, _) => _buildScaffold(null, Text('Error: $e')),
      loading: () =>
          _buildScaffold(ref, const Center(child: CircularProgressIndicator())),
    );
  }

  Widget _buildLlistaStudentAmbStream(
      {required AsyncValue<List<Student>> usersAsync, required WidgetRef ref}) {
    return usersAsync.when(
      data: (users) {
        return _buildScaffold(ref, _buildLlista(context, ref, users as List<T>));
      },
      error: (e, _) => _buildScaffold(null, Text('Error: $e')),
      loading: () =>
          _buildScaffold(ref, const Center(child: CircularProgressIndicator())),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (valueSearched == '') {
      return course != null
          ? _buildLlistaAmbNotifier(
              idsAsync: ref.watch(studentIdsProvider(course!.id!)),
              futureLlista: () => _carregaLlista(ref, course!.id),
              ref: ref,
            )
          : _buildLlistaAmbNotifier(
              idsAsync: ref.watch(asyncTeacherIdsProvider),
              futureLlista: () => _carregaLlista(ref, null),
              ref: ref,
            );
    } else {
      return course != null
          ? _buildLlistaStudentAmbStream(
              usersAsync:ref.watch(studentSearchStreamProvider((course!.id!, valueSearched))),
              ref: ref)
          : _buildLlistaTeacherAmbStream(
              usersAsync: ref.watch(teacherSearchStreamProvider(valueSearched)),
              ref: ref);
    }
  }
}
