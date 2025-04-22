import 'dart:core';
import 'dart:io';

import 'package:xml_fotos/utils/storage.dart';

class DirectoryUtil {
  static Future<Directory> get aDir async =>
      Directory('${(await StorageUtil.directory).path}/A');

  static Future<Directory> get pDir async =>
      Directory('${(await StorageUtil.directory).path}/P');

  static Future<void> ensureStructureExists(Directory dir) async {
    if (!await dir.exists()) await dir.create(recursive: true);
  }

  static Future<bool> hasContent(Directory dir) async {
    final dirFiles = dir.listSync(recursive: false);
    return dirFiles.isNotEmpty;
  }
}