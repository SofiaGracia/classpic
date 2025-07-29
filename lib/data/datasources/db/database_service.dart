import 'package:classpic/data/datasources/db/dao/course_dao.dart';

import 'dao/student_dao.dart';
import 'dao/teacher_dao.dart';
import 'database.dart'; // Where your AppDatabase is defined

class DatabaseService {
  static AppDatabase? _db;

  // References to the DAOs
  late StudentDao _studentDao;
  late TeacherDao _teacherDao;
  late CourseDao _courseDao;

  // Private instance for the singleton
  static final DatabaseService _instance = DatabaseService._internal();

  // Private constructor
  DatabaseService._internal();

  // Factory constructor to always return the same instance
  factory DatabaseService() {
    return _instance;
  }

  StudentDao get studentDao => _studentDao;
  TeacherDao get teacherDao => _teacherDao;
  CourseDao get courseDao => _courseDao;
  AppDatabase? get db => _db;

  // Connect to the database
  Future<AppDatabase> connectDB() async {
    try {
      if (_db != null) return _db!;
      _db = await $FloorAppDatabase
          .databaseBuilder('classpic_database.db')
          .build();
      _studentDao = _db!.studentDao;
      _teacherDao = _db!.teacherDao;
      _courseDao = _db!.courseDao;
      return _db!;
    } catch (e) {
      throw Exception("Error while connecting to the database: $e");
    }
  }

  // Disconnect from the database
  Future<void> disconnectDB() async {

    try{
      if (_db != null) {
        await _db!.close();
        _db = null;
      }
    }catch (e) {
      throw Exception("Error while disconnecting from the database: $e");
    }
  }
}

