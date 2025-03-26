
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:xml/xml.dart';

import '../models/grup.dart';

class RepositoryInfoXML {

  static Future<dynamic> carregaXML() async {
    final String xmlString = await rootBundle.loadString('assets/xml/alumnat.xml');
    try {
      final document = XmlDocument.parse(xmlString);
      return document;
    } catch (e) {
      print('Excepció: $e');
    }
  }
}