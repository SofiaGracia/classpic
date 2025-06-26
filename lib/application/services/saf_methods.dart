import 'package:flutter/services.dart';

const platform = MethodChannel('classpic/saf_methods');

Future<String?> createSubdirectory(String baseUri, String name) async {
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
