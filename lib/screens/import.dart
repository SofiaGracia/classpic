import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/sessio.dart';


class ImportScreen extends StatefulWidget {

  final Sessio sessio;
  final Function(Sessio sessio, String nomFitxerXml) onFileFound;

  ImportScreen({super.key, required this.onFileFound, required this.sessio});

  late String? nomFitxerXml = sessio.nomFitxerXml;

  @override
  State<ImportScreen> createState() => _ImportScreenState();
}

class _ImportScreenState extends State<ImportScreen> {

  void _seleccionarFitxer() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['xml']);

    if (result != null) {
      setState(() {
        widget.nomFitxerXml = result.files.single.name;
      });
      widget.onFileFound(widget.sessio, widget.nomFitxerXml!);
    }
  }

  void _carregarDades() {
    // Aquí cridaries la funció per carregar les dades del fitxer
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Carregant dades del fitxer ${widget.nomFitxerXml}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Importar dades d'alumnes"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Center(
                child: widget.nomFitxerXml == null
                    ? const Text("No s'ha seleccionat cap fitxer.",
                    style: TextStyle(fontSize: 18))
                    : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.insert_drive_file, size: 50, color: Colors.blue),
                    const SizedBox(height: 10),
                    Text(widget.nomFitxerXml!, style: const TextStyle(fontSize: 16))
                  ],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _seleccionarFitxer,
              child: const Text("Seleccionar un fitxer"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: widget.nomFitxerXml == null ? null : _carregarDades,
              child: const Text("Carregar dades"),
            ),
          ],
        ),
      ),
    );
  }
}
