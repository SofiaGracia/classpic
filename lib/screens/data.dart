import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:xml_fotos/utils/validator.dart';

import '../models/alumne.dart';
import '../models/professor.dart';
import '../models/usuari.dart'; // Si tens aquesta classe

class DataScreen extends StatefulWidget {
  final bool isAlumne;
  final Usuari? usuari; // pot ser Alumne o Professor

  const DataScreen({
    super.key,
    required this.isAlumne,
    this.usuari,
  });

  @override
  State<DataScreen> createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController niaDniController;
  late TextEditingController nomController;
  late TextEditingController cognom1Controller;
  late TextEditingController cognom2Controller;

  Uint8List? _imatge;

  @override
  void initState() {
    super.initState();
    final usuari = widget.usuari;
    niaDniController = TextEditingController(
        text: widget.isAlumne
            ? (usuari is Alumne ? usuari.nia : '')
            : (usuari is Professor ? usuari.dni : ''));
    nomController = TextEditingController(text: usuari?.nom ?? '');
    cognom1Controller = TextEditingController(text: usuari?.c1 ?? '');
    cognom2Controller = TextEditingController(text: usuari?.c2 ?? '');

    if (usuari?.fotoPath != null) {
      // Aquí pots carregar la foto del path si vols, o la pots deixar per més tard
      // Exemple: _foto = await File(usuari!.fotoPath!).readAsBytes();
    }
  }

  @override
  void dispose() {
    niaDniController.dispose();
    nomController.dispose();
    cognom1Controller.dispose();
    cognom2Controller.dispose();
    super.dispose();
  }

  Future<void> _seleccionarFoto() async {
    final picker = ImagePicker();
    final foto = await picker.pickImage(source: ImageSource.camera);
    if (foto != null) {
      final bytes = await foto.readAsBytes();
      setState(() {
        _imatge = bytes;
      });
    }
  }

  void _guardarUsuari() {
    final nomAGuardar = nomController.text.trim();
    final c1AGuardar = cognom1Controller.text.trim();
    final c2AGuardar = cognom2Controller.text.trim();
    final niaDniAGuardar = niaDniController.text.trim();

    if (widget.usuari != null) {
      // Actualització de l'usuari existent
      widget.usuari!
        ..nom = nomAGuardar
        ..c1 = c1AGuardar
        ..c2 = c2AGuardar;

      if (widget.isAlumne && widget.usuari is Alumne) {
        (widget.usuari as Alumne).nia = niaDniAGuardar;
      } else if (!widget.isAlumne && widget.usuari is Professor) {
        (widget.usuari as Professor).dni = niaDniAGuardar;
      }

      // Aquí pots afegir la gestió de la foto si vols:
      // widget.usuari!.fotoPath = _imatge != null ? guardarFoto(_imatge) : null;

      Navigator.pop(context, widget.usuari); // retornem l'usuari editat
    } else {
      // Creació d'un usuari nou
      if (widget.isAlumne) {
        final alumne = Alumne(
          nia: niaDniAGuardar,
          nom: nomAGuardar,
          c1: c1AGuardar,
          c2: c2AGuardar,
          fotoPath: null, // o guarda la foto si vols
        );
        Navigator.pop(context, alumne);
      } else {
        final professor = Professor(
          dni: niaDniAGuardar,
          nom: nomAGuardar,
          c1: c1AGuardar,
          c2: c2AGuardar,
          fotoPath: null,
        );
        Navigator.pop(context, professor);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.usuari == null
            ? (widget.isAlumne ? "Nou alumne" : "Nou professor")
            : (widget.isAlumne ? "Editar alumne" : "Editar professor")),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(
                controller: niaDniController,
                label: widget.isAlumne ? 'NIA' : 'DNI',
                validator: widget.isAlumne ? Validator.validarNia : Validator.validarDni,
                icon: Icons.badge,
                textCapitalization: TextCapitalization.characters,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                controller: nomController,
                label: 'Nom',
                validator: Validator.validarNom,
                icon: Icons.person,
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                controller: cognom1Controller,
                label: 'Cognom 1',
                validator: Validator.validarCognom1,
                icon: Icons.person_outline,
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                controller: cognom2Controller,
                label: 'Cognom 2',
                validator: null,
                icon: Icons.person_outline,
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: _seleccionarFoto,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _imatge != null ? MemoryImage(_imatge!) : null,
                  child: _imatge == null
                      ? const Icon(Icons.camera_alt, size: 40, color: Colors.white70)
                      : null,
                  backgroundColor: Colors.grey[400],
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _guardarUsuari();
                  }
                },
                icon: const Icon(Icons.save),
                label: const Text("Guardar"),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController? controller,
    required String label,
    String? Function(String?)? validator,
    required IconData icon,
    TextCapitalization textCapitalization = TextCapitalization.none,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      textCapitalization: textCapitalization,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(22)),
      ),
    );
  }
}
