import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../presentation/widgets/uri_dialog.dart';

class DialogHelper {
  static void mostrarDialogUri(BuildContext context, bool navigates) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (_) => UriDialog(navigates: navigates),
      );
    });
  }

  static void mostrarSnackBar(BuildContext context, String missatge) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(missatge)));
  }
}
