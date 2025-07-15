import 'package:xml_fotos/data/datasources/db/dao/curs_dao.dart';

import 'dao/alumne_dao.dart';
import 'dao/professor_dao.dart';
import 'database.dart'; // On tens la teva base de dades definides

class DatabaseService {
  static AppDatabase? _db;

  //Referencia al dao
  late AlumneDao _alumneDao;
  late ProfessorDao _professorDao;
  late CursDao _cursDao;

  // Instància privada per al singleton
  static final DatabaseService _instance = DatabaseService._internal();

  // Constructor privat
  DatabaseService._internal();

  // Factory constructor per retornar la mateixa instància cada vegada
  factory DatabaseService() {
    return _instance;
  }

  AlumneDao get alumneDao => _alumneDao;
  ProfessorDao get professorDao => _professorDao;
  CursDao get cursDao => _cursDao;
  AppDatabase? get db => _db;

  // Connectar-se a la base de dades
  Future<AppDatabase> connectaDB() async {
    try {
      if (_db != null) return _db!;
      _db = await $FloorAppDatabase
          .databaseBuilder('classpic_database.db')
          .build();
      _alumneDao = _db!.alumneDao;
      _professorDao = _db!.professorDao;
      _cursDao = _db!.cursDao;
      return _db!;
    } catch (e) {
      throw Exception("Error al connectar amb la base de dades: $e");
    }
  }

  // Desconnectar de la base de dades
  Future<void> desconnectaDB() async {

    try{
      if (_db != null) {
        await _db!.close();
        _db = null;
      }
    }catch (e) {
      throw Exception("Error al desconnectar amb la base de dades: $e");
    }
  }
}

