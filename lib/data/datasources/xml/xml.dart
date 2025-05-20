
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xml/xml.dart';


final RepositoryXmlProvider = Provider<RepositoryXml>((ref) {
  return RepositoryXml();
});

class RepositoryXml {

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
}