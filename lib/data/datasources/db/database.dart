// database_service.dart

// required package imports
import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import '../../../domain/entities/alumne.dart';
import '../../../domain/entities/curs.dart';
import '../../../domain/entities/professor.dart';
import 'dao/alumne_dao.dart';
import 'dao/curs_dao.dart';
import 'dao/professor_dao.dart';

part 'database.g.dart'; // the generated code will be there

//Defineix l’esquema de la base de dades SQLite de l’app,
// amb les entitats i DAOs que utilitzarà Floor per generar automàticament el codi d’accés a dades.
@Database(version: 13, entities: [Alumne, Professor, Curs])
abstract class AppDatabase extends FloorDatabase {
  AlumneDao get alumneDao;
  ProfessorDao get professorDao;
  CursDao get cursDao;
}