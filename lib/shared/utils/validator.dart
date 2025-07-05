import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../presentation/providers/alumne_notifier.dart';
import '../../presentation/providers/professor_notifier.dart';
import 'constants.dart';

class Validator {
  //Validar noms
  static String? validarNom(String? valor){
    if(valor == null || valor.isEmpty){
      return 'Per favor introdueix el nom';
    }
    return null;
  }
  //Validar primer cognom
  static String? validarCognom1(String? valor){
    if(valor == null || valor.isEmpty){
      return 'Per favor introdueix el cognom';
    }
    return null;
  }
  //Validar dni
  /*static String? validarDni(String? valor){
    if(valor == null || valor.isEmpty){
      return 'Per favor introdueix el dni';
    }
    return null;
  }

  //Validar nia
  static String? validarNia(String? valor){
    if(valor == null || valor.isEmpty){
      return 'Per favor introdueix el nia';
    }
    return null;
  }*/

  static String? validarUsuId(String? valor, WidgetRef ref, bool isAlumne, String? id){

    if(valor == null || valor.isEmpty){
      return 'Has d’omplir ID';
    }

    if(valor.length < numNia || valor.length > numMax){
      return 'L\'ID ha de tenir entre $numNia i $numMax caràcters.';
    }

    final llistaExistents = isAlumne
        ? ref.read(alumnesNotifierProvider).maybeWhen(
      data: (alumnes) => alumnes,
      orElse: () => [],
    )
        : ref.read(professorNotifierProvider).maybeWhen(
      data: (professors) => professors,
      orElse: () => [],
    );

    final idJaExisteix =
    llistaExistents.any((usuari) => usuari.usuId == valor && (id == null || id != valor));

    if(idJaExisteix){
      return 'Ja existeix un usuari amb aquest ID.';
    }
    return null;
  }
}