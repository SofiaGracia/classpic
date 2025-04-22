import 'package:flutter/material.dart';
import 'package:xml_fotos/models/alumne.dart';
import 'package:xml_fotos/models/professor.dart';

class UsuarisProvider extends ChangeNotifier {
  List<Alumne> _alumnes = [];
  List<Professor> _professors = [];

  List<Alumne> get alumnes => _alumnes;
  List<Professor> get professors => _professors;

  void setAlumnes(List<Alumne> nousAlumnes) {
    _alumnes = nousAlumnes;
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
}
