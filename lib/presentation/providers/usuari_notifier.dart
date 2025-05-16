import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xml_fotos/presentation/providers/alumne_notifier.dart';
import 'package:xml_fotos/presentation/providers/professor_notifier.dart';

import '../../domain/entities/alumne.dart';
import '../../domain/entities/professor.dart';
import '../../domain/models/usuari.dart';

final usuariProvider = NotifierProvider.family<UsuariNotifier, Usuari, String>(UsuariNotifier.new);

class UsuariNotifier extends FamilyNotifier<Usuari, String> {
  late final String id;
  late final _provider;

  @override
  Usuari build(String idParam) {
    id = idParam;
    final alumnes = ref.watch(alumnesNotifierProvider).value!;
    final professors = ref.watch(professorNotifierProvider).value!;
    final usuari = [...alumnes, ...professors].firstWhere((u) => getIdUsuari(u) == id);
    _provider = usuari is Alumne ? alumnesNotifierProvider : professorNotifierProvider;
    return usuari;
  }

  String getIdUsuari(Usuari u) => u is Alumne ? u.nia : (u as Professor).dni;

  Usuari _copyWithUsuari({
    String? nom,
    String? c1,
    String? c2,
    String? fotoPath,
    String? grup,
  }) {
    if (state is Alumne) {
      return (state as Alumne).copyWith(
        nom: nom,
        c1: c1,
        c2: c2,
        fotoPath: fotoPath,
        grup: grup,
      );
    } else if (state is Professor) {
      return (state as Professor).copyWith(
        nom: nom,
        c1: c1,
        c2: c2,
        fotoPath: fotoPath,
      );
    } else {
      throw Exception('Tipus d’usuari desconegut');
    }
  }

  void actualitzaNom(String nouNom) {
    state = _copyWithUsuari(nom: nouNom);
    _actualitzaGlobal();
  }

  void actualitzaCognoms(String c1, String c2) {
    state = _copyWithUsuari(c1: c1, c2: c2);
    _actualitzaGlobal();
  }

  void actualitzaFoto(String nouPath) {
    state = _copyWithUsuari(fotoPath: nouPath);
    _actualitzaGlobal();
  }

  void _actualitzaGlobal() {
    ref.read(_provider.notifier).actualitza(state);
  }
}
