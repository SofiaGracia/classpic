import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xml_fotos/presentation/providers/student/repository.dart';
import 'package:xml_fotos/presentation/providers/teacher/repository.dart';

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

  static String? validarUsuId(String? valor, WidgetRef ref, bool isAlumne){

    if(valor == null || valor.isEmpty){
      return 'Has d’omplir ID';
    }

    if(valor.length < numNia || valor.length > numMax){
      return 'L\'ID ha de tenir entre $numNia i $numMax caràcters.';
    }

    return null;
  }
}