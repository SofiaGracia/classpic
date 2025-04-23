import 'package:flutter/cupertino.dart';
import 'package:xml_fotos/database/database.dart';
import 'package:xml_fotos/models/usuari.dart';

import '../database/dao/alumne_dao.dart';
import '../database/dao/professor_dao.dart';
import '../models/alumne.dart';
import '../models/professor.dart';

enum Taula { alumnes, professors }

class UsuarisRepository {//També podria dir-se Usuaris repository

  //Referencia a la base de dades
  AppDatabase? _database;

  //Referencia al dao
  late AlumneDao _alumneDao;
  late ProfessorDao _professorDao;

  AlumneDao get alumneDao => _alumneDao;
  ProfessorDao get professorDao => _professorDao;

  UsuarisRepository._();

  static final UsuarisRepository _instance = UsuarisRepository._();

  factory UsuarisRepository(){
    return _instance;
  }

  Future<void> connectaDB() async {
    if (_database == null) {

      _database = await $FloorAppDatabase
          .databaseBuilder('data_base.db') //Com puc comprovar que este és el nom de la basededades?
          .build();

      _alumneDao = _database!.alumneDao;
      _professorDao = _database!.professorDao;
    }
  }

  Future<Map<String, dynamic>> carregaUsuaris() async {
    await connectaDB();

    final alumnes = await _alumneDao.findAllAlumnes();
    final professors = await _professorDao.findAllProfessors();

    return {
      'alumnes': alumnes,
      'professors': professors,
    };
  }

  //També hem d'eliminar o editar l'usuari de l'estructura de directoris
  Future<void> eliminarUsuari(Usuari usuari) async {
    if (usuari is Alumne) {
      await _alumneDao.deleteAlumne(usuari);
    } else if (usuari is Professor) {
      await _professorDao.deleteProfessor(usuari);
    }
  }

  Future<void> editarUsuari(Usuari usuari) async {
    if (usuari is Alumne) {
      await _alumneDao.updateAlumne(usuari);
    } else if (usuari is Professor) {
      await _professorDao.updateProfessor(usuari);
    }
  }
}
