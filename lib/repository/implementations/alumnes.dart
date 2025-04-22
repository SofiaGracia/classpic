import 'package:flutter/cupertino.dart';
import 'package:xml/xml.dart';
import 'package:xml_fotos/models/alumne.dart';
import 'package:xml_fotos/repository/implementations/xml.dart';
import 'package:xml_fotos/repository/interfaces/ialume.dart';

class RepositoryAlumne implements IRepositoryAlumne {

  RepositoryXml repo = RepositoryXml();

  @override
  Future<List<Alumne>> carregaLlistaAlumnes() async {

    //Retornarem una llista d'alumnes
    List<Alumne> llistaAlumnes = [];

    XmlDocument? doc = await repo.carregaInfo();

    try{
      if(doc!=null){

        final alumnesNode = doc.findAllElements('alumnos').first;
        final alumnes = alumnesNode.findElements('alumno');

        for (final alu in alumnes) {

          final mat = alu.getAttribute('estado_matricula');

          if(mat == Alumne.estatMatriculat){
            final aluNia = alu.getAttribute('NIA');
            final aluNom = alu.getAttribute('nombre');
            final aluC1 = alu.getAttribute('apellido1');
            final aluC2 = alu.getAttribute('apellido2');
            final aluGrup = alu.getAttribute('grupo');

            if(aluNia != null && aluNom != null && aluC1 != null){
              Alumne aluAInsertar = Alumne(
                  nia: aluNia,
                  nom: aluNom,
                  c1: aluC1,
                  c2: aluC2,
                  grup: aluGrup
              );

              llistaAlumnes.add(aluAInsertar);

            }
          }
        }
      }
    } catch (e) {
      debugPrint('Excepció: $e');
    }
    return llistaAlumnes;
  }
}