import 'package:flutter/material.dart';
import 'package:xml_fotos/models/alumne.dart';
import 'package:xml_fotos/models/professor.dart';

import '../models/usuari.dart';
import '../repository/usuaris.dart';

class UsuarisProvider extends ChangeNotifier {
  List<Alumne> _alumnes = [];
  List<Professor> _professors = [];
  Set<String?> _cursos = {};

  final UsuarisRepository _repo = UsuarisRepository();

  List<Alumne> get alumnes => _alumnes;
  List<Professor> get professors => _professors;
  Set<String?> get cursos => _cursos;

  void setAlumnes(List<Alumne> nousAlumnes) {
    //_alumnes = nousAlumnes;

    _alumnes = nousAlumnes.map((a) {
      final grupNet = (a.grup ?? '').trim();
      a.grup = grupNet.isEmpty ? 'Sense grup' : grupNet;
      return a;
    }).toList();

    // També actualitzem els cursos ara que els grups estan netejats
    _cursos = _alumnes.map((a) => a.grup).toSet();

    notifyListeners();
  }

  void setProfessors(List<Professor> nousProfessors) {
    _professors = nousProfessors;
    notifyListeners();
  }

  int get alumnesSenseFoto =>
      _alumnes.where((a) => a.fotoPath == null || a.fotoPath!.isEmpty).length;

  int get professorsSenseFoto =>
      _professors.where((p) => p.fotoPath == null || p.fotoPath!.isEmpty).length;

  void buida() {
    _alumnes = [];
    _professors = [];
    notifyListeners();
  }

  Future<void> eliminarUsuari(dynamic usuari) async {
    if (usuari is Alumne) {
      _alumnes.removeWhere((a) => a.nia == usuari.nia);
    } else if (usuari is Professor) {
      _professors.removeWhere((p) => p.dni == usuari.dni);
    }
    notifyListeners();
    await _repo.eliminarUsuari(usuari);
  }

  Future<void> editarUsuari(dynamic usuari) async {
    // Aquí pots fer la lògica de substitució, validació, etc.
    if (usuari is Alumne) {
      final index = _alumnes.indexWhere((a) => a.nia == usuari.nia);
      if (index != -1) _alumnes[index] = usuari;
    } else if (usuari is Professor) {
      final index = _professors.indexWhere((p) => p.dni == usuari.dni);
      if (index != -1) _professors[index] = usuari;
    }

    notifyListeners();
    await _repo.editarUsuari(usuari);
  }

  Future<void> insertarUsuari(Usuari usuari) async {
    if (usuari is Alumne) {
      _alumnes.add(usuari);
    } else if (usuari is Professor) {
      _professors.add(usuari);
    }
    notifyListeners();
    await _repo.insertarUsuari(usuari);
  }

  List<Alumne> getAlumnesDelGrup(String grup) =>
      _alumnes.where((a) => a.grup == grup).toList();

  void afegirCurs(String nouCurs) {
    _cursos.add(nouCurs);
    notifyListeners();
  }
}
