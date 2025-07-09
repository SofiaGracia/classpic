
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xml_fotos/domain/models/usuari.dart';

import '../../domain/entities/curs.dart';

class LlistaUsuarisStream<T extends Usuari> extends ConsumerWidget {
  final bool isAlumne;
  final Curs? curs;

  const LlistaUsuarisStream({
    super.key,
    required this.isAlumne,
    required this.curs
});

  String _getTitol(){
    return isAlumne? 'Alumnes de ${curs!.nom}': 'Professors';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //Llegir el stream d'ids del provider d'ids
    return Scaffold(

    );
  }
}