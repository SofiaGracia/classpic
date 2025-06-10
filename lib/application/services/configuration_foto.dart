import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/models/qualitat_foto.dart';

class ConfiguracioFotoService {
  static const _clauQualitat = 'qualitat_foto';

  Future<void> guardaQualitat(QualitatFoto qualitat) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_clauQualitat, qualitat.index);
  }

  Future<QualitatFoto> carregaQualitat() async {
    final prefs = await SharedPreferences.getInstance();
    final index = prefs.getInt(_clauQualitat) ?? QualitatFoto.mitjana.index;
    return QualitatFoto.values[index];
  }
}
