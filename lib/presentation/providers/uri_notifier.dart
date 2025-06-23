import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xml_fotos/shared/utils/constants.dart';

class UriNotifier extends AsyncNotifier<String?> {
  static const _methodGetUri = 'getUri';
  static const _channelName = 'classpic/saf_picker';

  static const platform = MethodChannel(_channelName);

  @override
  Future<String?> build() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyFolder);
  }

  // Actualitzar la uri: Canviar d'ubicació
  Future<void> updateUri() async {
    try {
      final String? uri = await platform.invokeMethod<String?>(_methodGetUri);

      if (uri != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(keyFolder, uri);
        state = AsyncData(uri);
      } else {
        // Si la uri és null, considerem que no hi ha URI i actualitzem l'estat
        state = const AsyncData(null);
      }
    } on PlatformException catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

final uriProvider = AsyncNotifierProvider<UriNotifier, String?>(
      () => UriNotifier(),
);
