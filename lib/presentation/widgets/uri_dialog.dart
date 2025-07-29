import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:classpic/shared/themes/basic_theme.dart';

class UriDialog extends StatelessWidget {

  final bool navigates;

  const UriDialog({super.key, required this.navigates});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Directori no configurat', style: getTheme(context).textTheme.titleLarge,),
      content: const Text(
        'Has de seleccionar una carpeta per a guardar les fotos.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel·lar'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            // 🔑 Navega a la pantalla de configuració:
            if(navigates){
              Navigator.pushNamed(context, '/config');
            }
          },
          child: Text(navigates?'Configurar':'Aceptar'),
        ),
      ],
    );
  }
}
