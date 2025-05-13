import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'exceptions.dart';

class ErrorHandler {
  // Mètode per transformar errors en missatges d'error amigables
  static String mapErrorToMessage(dynamic error) {
    // Tractar les excepcions personalitzades
    if (error is FitxerNoTrobatException) {
      return "El fitxer que busques no ha estat trobat. Si us plau, comprova el camí.";
    } else if (error is DirectoriNoTrobatException) {
      return "El directori no existeix. Assegura't que el directori estigui creat.";
    } else if (error is PermisDenegatException) {
      return "No tens permís per realitzar aquesta acció. Comprova els teus permisos.";
    } else if (error is FormatInvalidException) {
      return "El format de les dades és incorrecte. Revisa-les abans de continuar.";
    } else if (error is LecturaJsonException) {
      return "S'ha produït un error al llegir el fitxer JSON. Comprova el contingut.";
    } else if (error is OperacioNoPermesaException) {
      return "Aquesta operació no està permesa. Si us plau, revisa les teves accions.";
    } else if (error is ErrorDesconegutException) {
      return "S'ha produït un error desconegut. Si us plau, contacta amb el suport.";
    } else if (error is FileSystemException) {
      return "Hi ha hagut un problema amb els fitxers. Si us plau, torna a intentar-ho.";
    } else if (error is FormatException) {
      return "Les dades no són vàlides. Revisa les dades introduïdes.";
    } else if (error is TimeoutException) {
      return "El temps d'espera ha estat superat. Revisa la teva connexió a internet.";
    } else if (error is SocketException) {
      return "No es pot establir connexió amb el servidor. Si us plau, revisa la teva connexió.";
    } else if (error is Exception) {
      return "S'ha produït un error inesperat. Si el problema persisteix, contacta amb el suport.";
    } else {
      return "S'ha produït un error desconegut. Si us plau, torna a intentar-ho més tard.";
    }
  }

  // Mètode per mostrar l'error (a través de UI o un log)
  static void showErrorMessage(BuildContext context, dynamic error) {
    String message = mapErrorToMessage(error);

    // Mostrar el missatge a la UI (exemple amb SnackBar)
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}
