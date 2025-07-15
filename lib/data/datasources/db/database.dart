// database_service.dart

// required package imports
import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import '../../../domain/entities/student.dart';
import '../../../domain/entities/course.dart';
import '../../../domain/entities/teacher.dart';
import 'dao/student_dao.dart';
import 'dao/curs_dao.dart';
import 'dao/teacher_dao.dart';

part 'database.g.dart'; // the generated code will be there

@Database(version: 23, entities: [Student, Teacher, Course])
abstract class AppDatabase extends FloorDatabase {
  StudentDao get studentDao;
  TeacherDao get teacherDao;
  CursDao get cursDao;
}