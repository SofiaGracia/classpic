/*import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:xml_fotos/screens/widgets/usuari.dart';

import '../../models/alumne.dart';
import '../../models/professor.dart';
import '../../models/usuari.dart';

class LlistaUsuarisWidget extends StatelessWidget {
  final List<Usuari> usuaris;
  final bool isAlumne;
  final void Function(Usuari usuari)? onEditar;
  final void Function(Usuari usuari)? onEliminar;

  const LlistaUsuarisWidget({
    super.key,
    required this.usuaris,
    required this.isAlumne,
    this.onEditar,
    this.onEliminar,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: usuaris.length,
      itemBuilder: (context, index) {
        final usuari = usuaris[index];
        return UsuariTile(
          usuari: usuari,
          identificador: isAlumne
              ? (usuari as Alumne).nia
              : (usuari as Professor).dni,
          foto: usuari.fotoPath != null ? usuari.fotoPath as Uint8List : null,
          onEditar: () => onEditar?.call(usuari),
          onEliminar: () => onEliminar?.call(usuari),
        );
      },
    );
  }
}*/
