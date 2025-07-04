import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xml_fotos/application/services/codi_generator.dart';
import 'package:xml_fotos/application/services/storage_service.dart';
import 'package:xml_fotos/domain/models/usuari_factory.dart';
import 'package:xml_fotos/presentation/providers/uri_notifier.dart';
import 'package:xml_fotos/presentation/widgets/drop_down_button.dart';
import '../../application/services/saf_methods.dart';
import '../../domain/entities/alumne.dart';
import '../../domain/models/usuari.dart';
import '../providers/cursos_notifier.dart';
import '../../shared/utils/constants.dart';
import '../../shared/utils/validator.dart';
import '../widgets/foto_usuari.dart';
import '../widgets/uri_dialog.dart';
import 'camera_camera.dart';

// Aquesta pantalla permet crear o editar un usuari (alumne o professor)
class NewEditUserScreen<T extends Usuari> extends ConsumerStatefulWidget {
  final T? usuari; // Usuari a editar, null si és un nou usuari
  final String Function(T) getId; // Funció per obtenir l'ID del tipus T

  final bool isAlumne; // Indica si l'usuari és un alumne
  final int? cursId; // ID del curs si s'està creant un alumne
  final String? cursNom;
  final String codiUsuari; // Codi identificador (NIA, DNI o generat)
  final Uri? imageUser;

  const NewEditUserScreen({
    super.key,
    required this.usuari,
    required this.getId,
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
  final idFieldKey = GlobalKey<FormFieldState>();

  // Controladors pels camps del formulari
  late TextEditingController idController;
  late TextEditingController nomController;
  late TextEditingController cognom1Controller;
  late TextEditingController cognom2Controller;

  Uri? _imatge; // Ruta de la imatge de l'usuari
  Uint8List? foto;
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
    _fotoPathHashAGuardar = _fotoPathHashAGuardar ??
        DateTime.now().millisecondsSinceEpoch.toString();

    final usuari = widget.usuari;
    idController = TextEditingController(text: widget.codiUsuari);
    nomController = TextEditingController(text: usuari?.nom ?? '');
    cognom1Controller = TextEditingController(text: usuari?.c1 ?? '');
    cognom2Controller = TextEditingController(text: usuari?.c2 ?? '');
    if (widget.isAlumne) {
      _grupActual = widget.cursNom;
      grupSeleccionat = widget.cursNom;
      _grupActual ??= grupSensenom;
      grupSeleccionat ??= grupSensenom;
    }
  }

  Usuari crearUsuariGeneric() {
    final nouUsuari = UsuariFactory.create(
      isAlumne: widget.isAlumne,
      usuId: idController.text,
      nom: nomController.text.trim(),
      c1: cognom1Controller.text.trim(),
      c2: cognom2Controller.text.trim(),
      hasFoto: _imatge == null ? false : true,
      fotoPathHash: _fotoPathHashAGuardar ??
          DateTime.now().millisecondsSinceEpoch.toString(),
    );
    return nouUsuari;
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

      final usuariNou = crearUsuariGeneric();

      String? nomCursSeleccionat;
      if (usuariNou is Alumne) {
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

      final idActual = usuariActual?.usuId;
      if (foto != null) {
        //Guardem la foto
        final uri = await ref.read(uriProvider.notifier).getUri();
        final guardada = await PlatformChannel.savePhoto(
            uri: uri!,
            id: idController.text,
            tipusUsuari: widget.isAlumne ? 'Alumnes' : 'Professors',
            grup: nomCursSeleccionat,
            bytes: foto!);

        if (guardada) {
          //Posar a true el hasFoto encara que uri siga null
          usuariNou.hasFoto = true;
        }

      } else if ((_imatge != null) &&
          (idActual != null && idActual != idController.text)) {
        //Entrem a este cas si sí que tenim una foto i el id s'ha canviat per tant haurem de renombrar la foto

        final uri = await ref.read(uriProvider.notifier).getUri();

        await PlatformChannel.renameFile(
            uri: uri!,
            uriFoto: _imatge!,
            id: idController.text,
            tipusUsuari: widget.isAlumne ? 'Alumnes' : 'Professors');
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

  bool _validarId() {
    if (idController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Has d’omplir ID')),
      );
      return false;
    }
    return true;
  }

  void _mostrarDialogUri() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (_) => UriDialog(navigates: true),
      );
    });
  }

  // Obre la pantalla de càmera i actualitza la imatge si es fa una foto nova.
//
// Cas especial a tenir en compte:
// 1. S'obre la pantalla d'edició d'un usuari assignat al grup "3ESOC".
// 2. L'usuari canvia el grup al Dropdown a "1DAM".
// 3. Es fa la foto ➝ la URI de la foto s'emmagatzema amb "1DAM" com a grup.
// 4. Abans de guardar, l'usuari torna a canviar el grup a "3ESOC".
// 5. Quan es guarda l'usuari, aquest queda amb el grup "3ESOC", però la foto està guardada a la carpeta "1DAM".
// 6. Per tant, al sortir, el `Tile` no pot mostrar la foto perquè busca la imatge a "3ESOC", però està a "1DAM".
//
// ✅ Solució possible: Cal assegurar que la foto es mogui o es renomene si el grup canvia després de fer la foto.
  Future<void> _gestionaFoto() async {
    if (!_validarId()) return;

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

    if (uri == null) {
      _mostrarDialogUri();
      return;
    }

    final result = await Navigator.push<Uint8List?>(
      context,
      MaterialPageRoute(
        builder: (context) => CameraPage(
            //uri: uri,
            //id: idController.text,
            //tipusUsuari: widget.isAlumne ? 'Alumnes' : 'Professors',
            //grup: nomCursSeleccionat,
            ),
      ),
    );

    if (result != null) {
      setState(() {
        foto = result;

        _fotoPathHashAGuardar =
            DateTime.now().millisecondsSinceEpoch.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(usuariActual == null ? "Nou usuari" : "Editar usuari"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                key: idFieldKey,
                controller: idController,
                validator: (text) => Validator.validarUsuId(idController.text,
                    ref, widget.isAlumne, usuariActual?.usuId),
                textCapitalization: TextCapitalization.characters,
                decoration: InputDecoration(
                  labelText: "Identificador (NIA o DNI)",
                  prefixIcon: Icon(Icons.badge),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(22)),
                ),
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
                onTap: () {
                  final valid = idFieldKey.currentState?.validate();
                  if (valid == true) {
                    _gestionaFoto();
                  }
                },
                child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey.shade200,
                    child: FotoUsuariWidget(
                      uri: _imatge,
                      bytes: foto,
                      fotoPathHash:
                          //(widget.usuari as Usuari).fotoPathHash!,
                          _fotoPathHashAGuardar!,
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
