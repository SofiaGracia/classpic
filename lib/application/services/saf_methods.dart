import 'package:flutter/services.dart';

class PlatformChannel {
  static const platform = MethodChannel('classpic/saf_methods');

  static Future<String?> createSubdirectory(String baseUri, String name) async {
    try {
      final uri = await platform.invokeMethod<String>('createDirectory', {
        'baseUri': baseUri,
        'name': name,
      });
      return uri;
    } on PlatformException catch (e) {
      print("Error creating directory: ${e.message}");
      return null;
    }
  }

  /// Mètode per esborrar un fitxer
  static Future<bool> esborraFitxer(String filePath) async {
    try {
      final result = await platform.invokeMethod<bool>(
        'esborraFitxer',
        {'path': filePath},
      );
      return result ?? false;
    } on PlatformException catch (e) {
      print('Error esborrant fitxer: ${e.message}');
      return false;
    }
  }

}



