import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xml_fotos/application/services/codi_generator.dart';
import 'package:xml_fotos/application/services/storage_service.dart';
import 'package:xml_fotos/presentation/providers/uri_notifier.dart';
import 'package:xml_fotos/presentation/widgets/drop_down_button.dart';
import '../../application/services/saf_methods.dart';
import '../../domain/entities/alumne.dart';
import '../../domain/models/usuari.dart';
import '../providers/cursos_notifier.dart';
import '../../shared/utils/constants.dart';
import '../../shared/utils/validator.dart';
import '../widgets/foto_usuari.dart';
import 'camera_camera.dart';

// Aquesta pantalla permet crear o editar un usuari (alumne o professor)
class NewEditUserScreen<T extends Usuari> extends ConsumerStatefulWidget {
  final T? usuari; // Usuari a editar, null si és un nou usuari
  final String Function(T) getId; // Funció per obtenir l'ID del tipus T
  final T Function({
    required String id,
    required String nom,
    required String c1,
    required String c2,
    required bool hasFoto,
    String? fotoPathHash,
  }) constructor; // Constructor per crear una instància del tipus T
  final bool isAlumne; // Indica si l'usuari és un alumne
  final int? cursId; // ID del curs si s'està creant un alumne
  final String? cursNom;
  final String codiUsuari; // Codi identificador (NIA, DNI o generat)
  final Uri? imageUser;

  const NewEditUserScreen({
    super.key,
    required this.usuari,
    required this.getId,
    required this.constructor,
    required this.isAlumne,
    required this.codiUsuari,
    required this.imageUser,
    required this.cursNom,
    this.cursId,
  });

  @override
  ConsumerState<NewEditUserScreen<T>> createState() =>
      _NewEditUserScreenState<T>();
}

class _NewEditUserScreenState<T extends Usuari>
    extends ConsumerState<NewEditUserScreen<T>> {
  final _formKey = GlobalKey<FormState>();

  // Controladors pels camps del formulari
  late TextEditingController idController;
  late TextEditingController nomController;
  late TextEditingController cognom1Controller;
  late TextEditingController cognom2Controller;

  Uri? _imatge; // Ruta de la imatge de l'usuari
  String? _fotoPathHash; // Hash de la foto per invalidació de caché
  String? grupSeleccionat; // Grup seleccionat per a alumnes
  String? _grupActual;
  T? usuariActual; // Referència a l'usuari actual
  String? _fotoPathHashAGuardar;
  String? grupEnQueEsFaLaFoto;

  @override
  void initState() {
    super.initState();

    usuariActual = widget.usuari;
    _imatge = widget.imageUser;
    _fotoPathHash = widget.usuari?.fotoPathHash;
    _fotoPathHashAGuardar = _fotoPathHash;

    final usuari = widget.usuari;
    idController = TextEditingController(text: widget.codiUsuari);
    nomController = TextEditingController(text: usuari?.nom ?? '');
    cognom1Controller = TextEditingController(text: usuari?.c1 ?? '');
    cognom2Controller = TextEditingController(text: usuari?.c2 ?? '');
    if (usuari is Alumne) {
      _grupActual = widget.cursNom;
      grupSeleccionat = widget.cursNom;
      _grupActual ??= grupSensenom;
      grupSeleccionat ??= grupSensenom;
    }
  }

  // Guarda l'usuari (crear o editar)
  Future<void> _guardarUsuari() async {
    if (_formKey.currentState!.validate()) {
      final normalitzat =
          CodiGenerator.normalitzaIdentificador(idController.text);
      setState(() {
        // Si vols reescriure el camp amb el text normalitzat:
        idController.value = idController.value.copyWith(
          text: normalitzat,
          selection: TextSelection.collapsed(offset: normalitzat.length),
        );
      });

      // Creem la nova instància d'usuari
      final usuariNou = widget.constructor(
          id: idController.text,
          nom: nomController.text.trim(),
          c1: cognom1Controller.text.trim(),
          c2: cognom2Controller.text.trim(),
          fotoPathHash: _fotoPathHashAGuardar ??
              DateTime.now().millisecondsSinceEpoch.toString(),
          hasFoto: _imatge == null ? false : true);

      if (usuariNou is Alumne) {
        String? nomCursSeleccionat;
        int? idCursSeleccionat;

        grupSeleccionat ??= grupSensenom;

        final cursTrobat = await ref
            .read(cursosNotifierProvider.notifier)
            .getCursPerNom(grupSeleccionat!);

        nomCursSeleccionat = cursTrobat!.nom;
        idCursSeleccionat = cursTrobat.id;

        //Assignem a l'usuari nou el curs corresponent
        usuariNou.grup = nomCursSeleccionat;
        usuariNou.cursId = idCursSeleccionat;

        await _moureFotoSiCal(usuariNou, nomCursSeleccionat);
      }
      // Tornem enrere amb el nou usuari
      Navigator.pop(context, usuariNou);
    }
  }

  Future<void> _moureFotoSiCal(Alumne usuariNou, String grupNou) async {
    if (!usuariNou.hasFoto) return;

    final grupAntic = grupEnQueEsFaLaFoto ?? _grupActual;
    if (grupAntic != null && grupAntic != grupNou) {
      await ref
          .read(StorageServiceProvider)
          .mouFotoAlumne(grupAntic, grupNou, idController.text);
    }
  }

  // Obre la pantalla de càmera i actualitza la imatge si es fa una foto nova
  // La cosa és que es pot donar el seguent cas:
  /*
  * - S'obri la pantalla d'edició de l'usuari en un grup: 3ESOC
  *
  * - Es canvia de grup: En el dropdownbutton posem 1DAM
  *
  * - Es fa la foto: La uri de la  foto tindrà 1DAM
  *
  * - Es torna a canviar de grup: Per exemple posem com abans 3ESOC
  *
  * - Es guarda l'usuari, però al sortir no es veu la foto al Tile pq hem guardat la foto amb 1DAM i el grup actual
  * de l'usuari per a trobar la foto es 3ESOC
  *
  * */
  Future<void> _gestionaFoto() async {
    if (idController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Has d’omplir ID')),
      );
      return null;
    }
    String? nomCursSeleccionat;

    //grupSeleccionat realment no pot ser null
    if (widget.isAlumne && grupSeleccionat != null) {
      final cursTrobat = await ref
          .read(cursosNotifierProvider.notifier)
          .getCursPerNom(grupSeleccionat!);

      if (cursTrobat != null) {
        nomCursSeleccionat = cursTrobat.nom;
      }
    }

    final uri = await ref.read(uriProvider.notifier).getUri();

    final guardada = await Navigator.push<bool?>(
      context,
      MaterialPageRoute(
        builder: (context) => CameraPage(
          uri: uri!,
          id: idController.text,
          tipusUsuari: widget.isAlumne ? 'Alumnes' : 'Professor',
          grup: nomCursSeleccionat,
        ),
      ),
    );

    if (guardada == true) {
      //obtindre el uri
      final imageUser = widget.isAlumne
          ? await PlatformChannel.getFotoAlumneUri(
              nomCursSeleccionat!, idController.text)
          : await PlatformChannel.getFotoProfessorUri(idController.text);

      setState(() {
        _fotoPathHashAGuardar =
            DateTime.now().millisecondsSinceEpoch.toString();

        grupEnQueEsFaLaFoto = nomCursSeleccionat;

        //Assignar-ho a image
        _imatge = imageUser;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isNou = usuariActual == null;
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
                validator: (text) => Validator.validarUsuId(
                    idController.text,
                    ref,
                    widget.isAlumne,
                    usuariActual?.usuId),
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
                CursosDropdown(
                    cursId: widget.cursId!,
                    onGrupSeleccionat: (nomCurs) {
                      grupSeleccionat = nomCurs;
                    })
              ],
              const SizedBox(height: 30),
              GestureDetector(
                onTap: _gestionaFoto,
                child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey.shade200,
                    child: _imatge == null
                        ? const Icon(Icons.person)
                        : FotoUsuariWidget(
                            uri: _imatge,
                            fotoPathHash:
                                (widget.usuari as Usuari).fotoPathHash!,
                            radius: 30,
                          )),
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
