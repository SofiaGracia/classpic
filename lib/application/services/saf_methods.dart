import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../shared/utils/constants.dart';

class PlatformChannel {
  static String? _baseUriCache;
  static const platform = MethodChannel('classpic/saf_methods');

  static setBaseUri(String? newUri) {
    _baseUriCache = newUri;
  }

  static Uri? get baseUri =>
      _baseUriCache != null ? Uri.parse(_baseUriCache!) : null;

  static Future<String?> creaEstructuraProf() async {
    try {
      final uri = await platform.invokeMethod<String>('creaEstructuraProf', {
        'baseUri': _baseUriCache,
        'appName': baseFolderName,
      });
      return uri;
    } on PlatformException catch (e) {
      print("Error creating directory: ${e.message}");
      return null;
    }
  }

  static Future<String?> creaEstructuraAlu(List<String>? grups) async {
    try {
      final uri = await platform.invokeMethod<String>('creaEstructuraAlu', {
        'baseUri': _baseUriCache,
        'appName': baseFolderName,
        'grups': grups,
      });
      return uri;
    } on PlatformException catch (e) {
      print("Error creating directory: ${e.message}");
      return null;
    }
  }

  static Future<bool> eliminaFotos(List<Uri> uris) async {
    try {
      final result = await platform.invokeMethod<bool>('eliminaFotos', {
        'uris': uris.map((e) => e.toString()).toList(),
      });
      return result ?? false;
    } catch (e) {
      print('Error eliminant fotos: $e');
      return false;
    }
  }

  static Future<bool> esborraDirIContingut(
      String baseUri, List<String> nomCursos) async {
    try {
      final Map<dynamic, dynamic>? result = await platform.invokeMethod(
        'deleteGrupFolders',
        {
          'uri': baseUri,
          'appName': baseFolderName,
          'aluName': alumnesFolder,
          'grups': nomCursos,
        },
      );

      if (result == null) return false;

      // Convertim a Map<String, bool> si cal
      final resultats = result.cast<String, bool>();

      for (final res in resultats.values) {
        if (res == false) {
          return false;
        }
      }

      return true;
    } catch (e) {
      print('Error esborrant: $e');
      return false;
    }
  }

  static Future<Uri?> getFotoProfessorUri(String dni) async {
    if (_baseUriCache == null) {
      return null;
    }

    try {
      final uriString =
          await platform.invokeMethod<String?>('getProfessorPhotoUri', {
        'dni': dni,
        'uri': _baseUriCache,
      });
      return uriString != null ? Uri.parse(uriString) : null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<Uri?> getFotoAlumneUri(String grup, String nia) async {
    if (_baseUriCache == null) {
      return null;
    }
    final uriString;

    try {
      uriString = await platform.invokeMethod<String?>('getAlumnePhotoUri',
          {'nia': nia, 'uri': _baseUriCache, 'grup': grup});
      return uriString != null ? Uri.parse(uriString) : null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<Uint8List?> readBytesFromSafUri(Uri uri) async {
    final byteData = await MethodChannel('classpic/saf_methods')
        .invokeMethod<Uint8List>('readBytesFromUri', {
      'uri': uri.toString(),
    });
    return byteData;
  }

  static Future<bool> savePhoto({
    required String uri,
    required String id,
    required String tipusUsuari, // "Alumnes" o "Professor"
    String? grup, // només si és Alumne
    required Uint8List bytes,
  }) async {
    final List<String> grups = [];
    if (grup != null) {
      grups.add(grup);
    }

    final result = await platform.invokeMethod<bool>('savePhotoFile', {
      'uri': uri.toString(),
      'appName': baseFolderName,
      'id': id,
      'tipusUsuari': tipusUsuari,
      'grup': grup == null ? grup : grups,
      'bytes': bytes,
    });

    return result ?? false;
  }

  static Future<bool> renameFile({
    required String uri,
    required Uri uriFoto,
    required String id,
    required String tipusUsuari, // "Alumnes" o "Professor"
    String? grup, // només si és Alumne
  }) async {
    final bytesOrigen = await readBytesFromSafUri(uriFoto);

    if (bytesOrigen == null) {
      return false;
    }

    final guardada = await savePhoto(
        uri: uri,
        id: id,
        tipusUsuari: tipusUsuari,
        grup: grup,
        bytes: bytesOrigen);

    if (guardada) {
      //Si es guarda borram la foto anterior
      List<Uri> uris = [];
      uris.add(uriFoto);

      await eliminaFotos(uris);

      return true;
    } else {
      return false;
    }
  }

  static Future<bool?> createFolder({
    required String uri,
    required String tipusUsuari, // "Alumnes" o "Professor"
    String? grup, // només si és Alumne
  }) async {
    final List<String> grups = [];
    if (grup != null) {
      grups.add(grup);
    }

    final result = await platform.invokeMethod<bool>('createFolder', {
      'uri': uri.toString(),
      'appName': baseFolderName,
      'tipusUsuari': tipusUsuari,
      'grup': grup == null ? grup : grups,
    });

    return result;
  }

  static Future<String?> renameFolder({
    required String newName,
    required String uri,
    required String tipusUsuari, // "Alumnes" o "Professor"
    String? grup, // només si és Alumne
  }) async {
    final result = await platform.invokeMethod<String?>('renameFolder', {
      'newName': newName,
      'uri': uri.toString(),
      'appName': baseFolderName,
      'tipusUsuari': tipusUsuari,
      'grup': grup,
    });

    return result ?? 'Error';
  }

  static Future<bool> checkBaseDirExists(
      {required String uri, required String folder}) async {
    try {
      final result = await platform.invokeMethod('checkUri', {
        'uri': uri,
        'appName': baseFolderName,
        'folder': folder,
      });
      return result;
    } catch (e) {
      print('$e');
    }
    return false;
  }

  static Future<bool> checkFolderHasPhotos(
      {required String uri,
      required String tipusUsuari,
      required List<String>? grups}) async {
    try {
      final result = await platform.invokeMethod('checkFolderHasPhotos', {
        'uri': uri,
        'appName': baseFolderName,
        'user': tipusUsuari,
        'groups': grups,
      });
      return result;
    } catch (e) {
      print('$e');
    }
    return false;
  }
}
