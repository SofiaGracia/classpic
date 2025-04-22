import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';

import 'errorhandler.dart';

class StorageUtil {

  static Directory? _extDir;

  /// Inicialitza el directori només una vegada
  static Future<void> init() async {
    try {
      _extDir = await getExternalStorageDirectory();
      _extDir ??= Directory("/storage/emulated/0/MyApp");
    } catch (e) {
      final errorMessage = ErrorHandler.mapErrorToMessage(e);
      debugPrint(errorMessage);
      _extDir = Directory("/storage/emulated/0/MyApp");
    }
  }

  /// Retorna el directori (assegura’t que `init()` s'ha cridat abans)
  static Directory get directory {
    if (_extDir == null) {
      throw Exception("StorageUtil no està inicialitzat. Crida init() primer.");
    }
    return _extDir!;
  }

  /// Retorna el path com a String
  static String get path => directory.path;

}