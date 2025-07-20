import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xml_fotos/presentation/providers/alumne_notifier.dart';
import 'package:xml_fotos/presentation/providers/professor_notifier.dart';
import 'package:xml_fotos/presentation/providers/student/student_ids_async.dart';
import 'package:xml_fotos/presentation/providers/teacher/teachers_ids_async.dart';
import 'package:xml_fotos/presentation/screens/courses_list.dart';
import 'package:xml_fotos/presentation/widgets/counter.dart';
import 'package:xml_fotos/presentation/widgets/status_button_riverpod.dart';

import '../../domain/entities/student.dart';
import '../../domain/entities/teacher.dart';
import '../providers/student/stream.dart';
import '../providers/teacher/stream.dart';
import 'configuration.dart';
import 'users_list.dart';

class MenuScreen extends ConsumerStatefulWidget {
  const MenuScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MenuScreenState();
}

class _MenuScreenState extends ConsumerState<MenuScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Menu',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Accés a alumnes i professors',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              // Button for students
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StatusButtonR(
                      text: 'Alumnes',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ListCoursesScreen(),
                          ),
                        );
                      },
                      provider: alumnesNotifierProvider),
                  const SizedBox(width: 8),
                  CounterWidget<Student>(
                    totalBuilder: (ref) => studentIdsProvider(null),
                    withPhoto: studentHasPhotoStreamProvider,
                  )
                ],
              ),
              // Button for teachers
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StatusButtonR(
                      text: 'Professors',
                      onPressed: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UsersListScreen<Teacher>(
                              curs: null,
                            ),
                          ),
                        );
                      },
                      provider: professorNotifierProvider),
                  const SizedBox(width: 8),
                  CounterWidget<Teacher>(
                    totalBuilder: (ref) => asyncTeacherIdsProvider,
                    withPhoto: teacherHasPhotoStreamProvider,
                  )
                ],
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ConfigurationScreen(),
                    ),
                  );
                },
                child: const Text('Configuració'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
