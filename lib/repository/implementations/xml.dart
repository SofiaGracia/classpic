
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:xml/xml.dart';

import '../interfaces/ixml.dart';

class RepositoryXml  implements IRepositoryXml {

  static Future<XmlDocument> getDocumentXML(FilePickerResult result) async {
    try {
      final filePath = result.files.single.path;
      if (filePath == null) throw Exception('Fitxer no vàlid');

      final fileContent = await File(filePath).readAsString();
      final document = XmlDocument.parse(fileContent);
      return document;
    } catch (e) {
      throw Exception('Error llegint o parsejant l\'XML: $e');
    }
  }

  @override
  Future<XmlDocument?> carregaInfo() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xml'],
      );

      if (result != null) {
        return await getDocumentXML(result);
      } else {
        throw Exception('L\'usuari ha cancel·lat la selecció del fitxer');
      }
    } catch (e) {
      throw Exception('No s\'ha pogut carregar l\'XML: $e');
    }
  }
  /*@override
  Future<List> carregaInfo() async {
    XmlDocument document = await RepositoryInfoXML.carregaXML() as XmlDocument;

    final alumnosNode = document
        .findAllElements('alumnos')
        .first;
    final students = alumnosNode.findElements('alumno');

    final grupsSet = <String>{};

    for (final student in students) {
      var grupStudent = student.getAttribute('grupo');
      if (grupStudent != null) {
        grupStudent = grupStudent.trim();
        if(grupStudent.isNotEmpty){
          grupsSet.add(grupStudent);
        }
      }
    }

    // Convertir a llista i ordenar alfabèticament
    List<String> grupsOrdenats = grupsSet.toList()..sort();

    return grupsOrdenats;
  }*/
}