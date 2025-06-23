import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xml_fotos/shared/utils/constants.dart';

class UriNotifier extends AsyncNotifier<String?> {
  @override
  Future<String?> build() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyFolder);
  }
}

final uriProvider = AsyncNotifierProvider<UriNotifier,String?>((){
  return UriNotifier();
});
