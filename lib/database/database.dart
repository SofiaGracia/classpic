// database.dart

// required package imports
import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import '../models/alumne.dart';
import '../models/professor.dart';
import 'dao/alumne_dao.dart';
import 'dao/professor_dao.dart';

part 'database.g.dart'; // the generated code will be there

@Database(version: 5, entities: [Alumne, Professor])
abstract class AppDatabase extends FloorDatabase {
  AlumneDao get alumneDao;
  ProfessorDao get professorDao;
}