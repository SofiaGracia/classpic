import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/services/storage_service.dart';

final inicialitzacioProvider = FutureProvider<void>((ref) async {
  final storage = ref.read(StorageServiceProvider);
  await storage.creaEstructuraInicial();
});
