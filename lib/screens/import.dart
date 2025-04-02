import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ImportScreen extends StatefulWidget {
  const ImportScreen({super.key});

  @override
  State<ImportScreen> createState() => _ImportScreenState();
}

class _ImportScreenState extends State<ImportScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Importar dades d\'alumnes'),
      ),
      body: Center(
        child: Text('Pantalla per importar dades'),
      ),
    );
  }
}
