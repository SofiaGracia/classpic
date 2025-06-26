import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xml_fotos/presentation/providers/uri_notifier.dart';

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

  static Future<Uri?> getFotoProfessorUri(WidgetRef ref, String dni) async {

    final uri = await ref.read(uriProvider.notifier).getUri();

    final uriString = await platform.invokeMethod<String>('getProfessorPhotoUri', {
      'dni': dni,
      'uri': uri,
    });
    return uriString != null ? Uri.parse(uriString) : null;
  }

  static Future<Uri?> getFotoAlumneUri(WidgetRef ref, String grup, String nia) async {

    final uri = await ref.read(uriProvider.notifier).getUri();

    final uriString = await platform.invokeMethod<String>('getAlumnePhotoUri', {
      'nia': nia,
      'uri': uri,
      'grup':grup
    });
    return uriString != null ? Uri.parse(uriString) : null;
  }

  static Future<Uint8List?> readBytesFromSafUri(Uri uri) async {
    final byteData = await MethodChannel('classpic/saf_methods')
        .invokeMethod<Uint8List>('readBytesFromUri', {
      'uri': uri.toString(),
    });
    return byteData;
  }

}



