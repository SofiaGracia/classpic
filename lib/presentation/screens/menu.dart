import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xml_fotos/presentation/providers/student/student_ids_async.dart';
import 'package:xml_fotos/presentation/providers/teacher/teachers_ids_async.dart';
import 'package:xml_fotos/presentation/screens/courses_list.dart';
import 'package:xml_fotos/presentation/widgets/counter.dart';
import 'package:xml_fotos/presentation/widgets/status_button_riverpod.dart';
import 'package:xml_fotos/shared/themes/basic_theme.dart';
import 'package:xml_fotos/shared/utils/constants.dart';

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
          title: Center(
            child: Text(
              'Menu',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          backgroundColor: menuBackground,
        ),
        body: Stack(
          children: [
            Expanded(child: Container(color: menuBackground)),
            Align(
              alignment: Alignment.bottomCenter,
              child: FractionallySizedBox(
                  heightFactor: 0.6, // ocupa meitat inferior
                  widthFactor: 1.0,
                  child: Card(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0),
                        ),
                      ),
                      margin: EdgeInsets.zero,
                      child: ListView(
                        padding: const EdgeInsets.all(40.0),
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Accés a alumnes i professors',
                                style: getTheme(context).textTheme.titleLarge,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 24),
                              // Button for students
                              CounterWidget<Student>(
                                totalBuilder: (ref) => studentIdsProvider(null),
                                withPhoto: studentHasPhotoStreamProvider,
                              ),
                              StatusButtonR(
                                  text: 'Alumnes',
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ListCoursesScreen(),
                                      ),
                                    );
                                  },
                                  totalBuilder: (ref) =>
                                      studentIdsProvider(null)),
                              const SizedBox(height: 24),
                              CounterWidget<Teacher>(
                                totalBuilder: (ref) => asyncTeacherIdsProvider,
                                withPhoto: teacherHasPhotoStreamProvider,
                              ),
                              // Button for teachers
                              StatusButtonR(
                                text: 'Professors',
                                onPressed: () async {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          UsersListScreen<Teacher>(
                                        curs: null,
                                      ),
                                    ),
                                  );
                                },
                                totalBuilder: (ref) => asyncTeacherIdsProvider,
                              ),
                              const SizedBox(height: 30),
                              ElevatedButton(
                                onPressed: () async {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ConfigurationScreen(),
                                    ),
                                  );
                                },
                                child: const Text('Configuració'),
                                style:
                                    getStyleElevatedButton(context, themeColor),
                              ),
                            ],
                          ),
                        ],
                      ))),
            ),
          ],
        ));
  }
}
