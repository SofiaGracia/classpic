import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/services/configuration_foto.dart';
import '../../domain/models/qualitat_foto.dart';

final configuracioFotoServiceProvider = Provider((ref) => ConfiguracioFotoService());

final qualitatFotoProvider = FutureProvider<QualitatFoto>((ref) async {
  final servei = ref.read(configuracioFotoServiceProvider);
  return await servei.carregaQualitat();
});
