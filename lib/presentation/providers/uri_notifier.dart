import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:classpic/application/services/check_dir.dart';
import 'package:classpic/shared/utils/constants.dart';

import '../../application/services/dir_structure.dart';
import '../../application/services/saf_methods.dart';
import '../../shared/utils/dialog/delete.dart';

class UriNotifier extends AsyncNotifier<String?> {
  static const _methodGetUri = 'getUri';
  static const _channelName = 'classpic/saf_methods';

  static const platform = MethodChannel(_channelName);

  @override
  Future<String?> build() async {
    final prefs = await SharedPreferences.getInstance();
    final uri = prefs.getString(keyFolder);
    PlatformChannel.setBaseUri(uri);
    return uri;
  }

  // Actualitzar la uri: Canviar d'ubicació
  Future<void> updateUri(BuildContext context) async {
    try {
      final String? uri = await platform.invokeMethod<String?>(_methodGetUri);

      if (uri != null) {
        //Comprovar si la uri és de un directori que té dades o no
        //Mostrarem un dialog si sí guardar la uri en el shared preferences i si no no
        final messageDialog = await CheckDirService(ref).checkDir(context, uri);
        if (messageDialog == true) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(keyFolder, uri);
          state = AsyncData(uri);

          //Li passem la info a PlatformChannel
          PlatformChannel.setBaseUri(uri);

          //Ací cridarem al mètode per a crear l'estructura de carpetes
          await DirStrucService.creaEstructuraInicial(uri);
        }
      } else {
        // Si la uri és null, considerem que no hi ha URI i actualitzem l'estat
        state = const AsyncData(null);
      }
    } on PlatformException catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<String?> getUri() async {
    final current = state;

    if (current is AsyncData) {
      return current.value;
    } else {
      // Opció 1: esperar que carregue si tens accés a la funció que el carrega
      state = const AsyncLoading();
      state = await AsyncValue.guard(() async {
        final prefs = await SharedPreferences.getInstance();
        return prefs.getString(keyFolder);
      });
      return state.requireValue; // ara ja sí!
    }
  }
}

final UriProvider = AsyncNotifierProvider<UriNotifier, String?>(
  () => UriNotifier(),
);
