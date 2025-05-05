import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../models/alumne.dart';
import '../models/curs.dart';
import '../models/usuari.dart';
import '../providers/cursos_notifier.dart';
import '../utils/validator.dart';

class NewEditUserScreen<T extends Usuari> extends ConsumerStatefulWidget {
  final T? usuari;
  //final bool isAlumne;
  final String Function(T) getId;
  final T Function({
    required String id,
    required String nom,
    required String c1,
    required String c2,
    String? fotoPath,
    String? grup
  }) constructor;
  final bool isAlumne;
  final int? cursId;

  const NewEditUserScreen({
    super.key,
    required this.usuari,
    required this.getId,
    required this.constructor,
    required this.isAlumne,
    this.cursId,
    //required this.isAlumne,
  });

  @override
  ConsumerState<NewEditUserScreen<T>> createState() => _NewEditUserScreenState<T>();
}

class _NewEditUserScreenState<T extends Usuari> extends ConsumerState<NewEditUserScreen<T>> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController idController;
  late TextEditingController nomController;
  late TextEditingController cognom1Controller;
  late TextEditingController cognom2Controller;

  Uint8List? _imatge;
  String? grupSeleccionat;

  @override
  void initState() {
    super.initState();
    final usuari = widget.usuari;
    idController = TextEditingController(text: usuari != null? widget.getId(usuari) : '');
    nomController = TextEditingController(text: usuari?.nom ?? '');
    cognom1Controller = TextEditingController(text: usuari?.c1 ?? '');
    cognom2Controller = TextEditingController(text: usuari?.c2 ?? '');
    if (usuari is Alumne) {
      grupSeleccionat = usuari.grup;
    }
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
    if (_formKey.currentState!.validate()) {
      int? idCursSeleccionat;
      String? nomCursSeleccionat;

      if (widget.isAlumne && grupSeleccionat != null) {
        final cursos = ref.read(cursosNotifierProvider).maybeWhen(
          data: (cursos) => cursos,
          orElse: () => [],//Ací tenim un orElse
        );

        final cursTrobat = _trobaCurs(cursos as List<Curs>);

        if (cursTrobat != null) {
          idCursSeleccionat = cursTrobat.id;
          nomCursSeleccionat = cursTrobat.nom;
        }
      }

      final usuariNou = widget.constructor(
        id: idController.text.trim(),
        nom: nomController.text.trim(),
        c1: cognom1Controller.text.trim(),
        c2: cognom2Controller.text.trim(),
        fotoPath: null,
        grup: nomCursSeleccionat,
      );

      if (usuariNou is Alumne) {
        usuariNou.cursId = idCursSeleccionat;
      }

      Navigator.pop(context, usuariNou);
    }
  }

  Curs? _trobaCurs(List<Curs> cursos){
    for(Curs curs in cursos){
      if (curs.nom == grupSeleccionat){
        return curs;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {

    final cursosAsync = widget.isAlumne
        ? ref.watch(cursosNotifierProvider)
        : const AsyncValue.data([]);

    final isNou = widget.usuari == null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isNou ? "Nou usuari" : "Editar usuari"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(
                controller: idController,
                label: "Identificador (NIA o DNI)",
                //validator: Validator.validarDniONia,
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
              if (widget.isAlumne) ...[
                cursosAsync.when(
                  data: (cursos) {
                    final curs = _trobaCurs(cursos as List<Curs>);
                    final valorInicial = curs != null? curs.id.toString(): cursos.first.id.toString();
                    return DropdownButtonFormField<String>(
                      value: grupSeleccionat == null ? null : valorInicial,
                      onChanged: (nouId) {
                        final nomDelGrup = cursos.firstWhere((c) => c.id.toString() == nouId).nom;
                        setState(() {
                          grupSeleccionat = nomDelGrup;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: "Curs",
                        border: OutlineInputBorder(),
                      ),
                      items: cursos.map((c) {
                        return DropdownMenuItem<String>(
                          value: c.id.toString(),
                          child: Text(c.nom),
                        );
                      }).toList(),
                    );
                  },
                  loading: () => const CircularProgressIndicator(),
                  error: (e, _) => Text('Error carregant cursos: $e'),
                ),
              ],
              GestureDetector(
                onTap: _seleccionarFoto,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage:
                      _imatge != null ? MemoryImage(_imatge!) : null,
                  child: _imatge == null
                      ? const Icon(Icons.camera_alt,
                          size: 40, color: Colors.white70)
                      : null,
                  backgroundColor: Colors.grey[400],
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: _guardarUsuari,
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
    required TextEditingController controller,
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
