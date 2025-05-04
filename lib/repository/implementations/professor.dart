import 'package:flutter/cupertino.dart';
import 'package:xml/xml.dart';
import 'package:xml_fotos/models/alumne.dart';
import 'package:xml_fotos/models/professor.dart';
import 'package:xml_fotos/repository/implementations/xml.dart';
import 'package:xml_fotos/repository/interfaces/ialume.dart';
import 'package:xml_fotos/repository/interfaces/iprofessor.dart';

class RepositoryProfessor implements IRepositoryProfessor {

  RepositoryXml repo = RepositoryXml();

  @override
  Future<List<Professor>> carregaLlistaProfessorsXml() async {

    //Retornarem una llista de professors
    List<Professor> llistaProfessors = [];

    XmlDocument? doc = await repo.carregaInfo();

    try{
      if(doc!=null){

        final profesNode = doc.findAllElements('docentes').first;
        final profes = profesNode.findElements('docente');

        for (final prof in profes) {

          final profDni = prof.getAttribute('documento');
          final profNom = prof.getAttribute('nombre');
          final profC1 = prof.getAttribute('apellido1');
          final profC2 = prof.getAttribute('apellido2');

          if(profDni != null && profNom != null && profC1 != null){
            Professor profAInsertar = Professor(dni: profDni, nom: profNom, c1: profC1, c2: profC2);
            llistaProfessors.add(profAInsertar);
          }
        }
      }
    } catch (e) {
      debugPrint('Excepció: $e');
    }
    return llistaProfessors;
  }

  @override
  Future<List<Professor>> carregaProfessorsFloor() {
    // TODO: implement carregaProfessorsFloor
    throw UnimplementedError();
  }

  @override
  Future<void> editarProfessorFloor(Professor professor) {
    // TODO: implement editarProfessorFloor
    throw UnimplementedError();
  }

  @override
  Future<void> eliminarProfessorFloor(String nia) {
    // TODO: implement eliminarProfessorFloor
    throw UnimplementedError();
  }

  @override
  Future<void> insertarProfessorFloor(Professor professor) {
    // TODO: implement insertarProfessorFloor
    throw UnimplementedError();
  }
}