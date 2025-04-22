import 'package:flutter/cupertino.dart';
import 'package:xml_fotos/database/database.dart';
import 'package:xml_fotos/models/persona.dart';

import '../database/dao/alumne_dao.dart';
import '../database/dao/professor_dao.dart';

enum Taula { alumnes, professors }

class DBStatusRepository {

  //Referencia a la base de dades
  AppDatabase? _database;

  //Referencia al dao
  late AlumneDao _alumneDao;
  late ProfessorDao _professorDao;

  AlumneDao get alumneDao => _alumneDao;
  ProfessorDao get professorDao => _professorDao;

  DBStatusRepository._();

  static final DBStatusRepository _instance = DBStatusRepository._();

  factory DBStatusRepository(){
    return _instance;
  }

  Future<void> connectaDB() async {
    if (_database == null) {

      _database = await $FloorAppDatabase
          .databaseBuilder('basedades.db') //Com puc comprovar que este és el nom de la basededades?
          .build();

      _alumneDao = _database!.alumneDao;
      _professorDao = _database!.professorDao;
    }
  }

  Future<Map<String, dynamic>> carregaAlumnesIProfessors() async {
    await connectaDB();

    final alumnes = await _alumneDao.findAllAlumnes();
    final professors = await _professorDao.findAllProfessors();

    return {
      'alumnes': alumnes,
      'professors': professors,
    };
  }

  Future<void> eliminarUsuari(PersonaBase usuari) async {
    debugPrint('Has pres eliminarUsuari');
  }

  Future<void> editarUsuari(PersonaBase usuari) async {
    debugPrint('Has pres editarUsuari');
  }
}
