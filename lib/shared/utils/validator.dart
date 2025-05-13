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
  static String? validarDni(String? valor){
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
  }
}