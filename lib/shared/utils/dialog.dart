import 'package:flutter/material.dart';

Future<bool?> showConfirmacioEliminacioDialog({
  required BuildContext context,
  required String titol,
  required String missatge,
  String botoConfirmar = 'Sí, eliminar',
  String botoCancel = 'Cancel·la',
}) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(titol),
        content: Text(missatge),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(botoCancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(botoConfirmar),
          ),
        ],
      );
    },
  );
}
