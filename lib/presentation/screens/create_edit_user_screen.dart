import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xml_fotos/application/services/storage_service.dart';
import 'package:xml_fotos/shared/utils/constants.dart';

import '../../application/services/codi_generator.dart';
import '../../application/services/saf_methods.dart';
import '../../domain/entities/student.dart';
import '../../domain/models/user.dart';
import '../../domain/models/user_factory.dart';
import '../../shared/utils/dialog/uri.dart';
import '../../shared/utils/validator.dart';
import '../providers/cursos_notifier.dart';
import '../providers/student/repository.dart';
import '../providers/teacher/repository.dart';
import '../providers/uri_notifier.dart';
import '../widgets/drop_down_button.dart';
import '../widgets/foto_usuari.dart';
import '../widgets/uri_dialog.dart';
import 'camera_camera.dart';

class CreateEditUserScreen<T extends User> extends ConsumerStatefulWidget {
  final T? usuari;

  //Referent a curs
  final bool isAlumne;
  final int? cursId;
  final String? cursNom;

  //Referent a usuari
  final String codiUsuari;
  final Uri? uriImageUser;

  const CreateEditUserScreen(
      {super.key,
      required this.usuari,
      required this.isAlumne,
      required this.cursId,
      required this.cursNom,
      required this.codiUsuari,
      required this.uriImageUser});

  @override
  _CreateEditUserScreenState<T> createState() =>
      _CreateEditUserScreenState<T>();
}

class _CreateEditUserScreenState<T extends User>
    extends ConsumerState<CreateEditUserScreen> {
  //FORMULARI:
    final _formKey = GlobalKey<FormState>();
  final idFieldKey = GlobalKey<FormFieldState>();

  // Controladors pels camps del formulari
  late TextEditingController idController;
  late TextEditingController nomController;
  late TextEditingController cognom1Controller;
  late TextEditingController cognom2Controller;

  //VARIABLES:
  User? usuari;
  late bool isAlumne;
  Uri? uriImageUser;
  String? fotoPathHash;

  //Si l'usuari nou a editar o crear és student:
  String? nomCursActual;
  String? nomCursSeleccionat;

  //VARIABLES AMB LES QUE COMPARAR:
  Uint8List? foto;
  late String fotoPathHashAGuardar;
  late String idActual;
  late String idGuardaUsuari;
  String? idAmbQueEsFaLaFoto;
  late String cursAmbQueShaFetLaFoto;
  bool faFaltaMoure = true;

  @override
  void initState() {
    super.initState();
    usuari = widget.usuari;

    //VARIABLES:
    isAlumne = widget.isAlumne;
    uriImageUser = widget.uriImageUser;
    fotoPathHash = usuari?.photoPathHash;
    fotoPathHashAGuardar =
        fotoPathHash ?? DateTime.now().millisecondsSinceEpoch.toString();

    idActual = widget.codiUsuari;
    idGuardaUsuari = widget.codiUsuari;

    if (isAlumne) {
      nomCursActual = widget.cursNom ?? grupSensenom;
      nomCursSeleccionat = widget.cursNom ?? grupSensenom;
      cursAmbQueShaFetLaFoto = widget.cursNom ?? grupSensenom;
    }

    //FORMULARI:
    idController = TextEditingController(text: widget.codiUsuari);
    nomController = TextEditingController(text: usuari?.name ?? '');
    cognom1Controller = TextEditingController(text: usuari?.s1 ?? '');
    cognom2Controller = TextEditingController(text: usuari?.s2 ?? '');
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

  User crearUsuariGeneric() {
    final nouUsuari = UserFactory.create(
      isAlumne: isAlumne,
      uId: idGuardaUsuari,
      name: nomController.text.trim(),
      s1: cognom1Controller.text.trim(),
      s2: cognom2Controller.text.trim(),
      hasFoto: uriImageUser == null ? false : true,
      photoPathHash: fotoPathHash,
    );
    return nouUsuari;
  }

  Future<void> _moureFotoSiCal(Student usuariNou, String grupNou) async {
    if (!usuariNou.hasFoto) return;

    final grupAntic = cursAmbQueShaFetLaFoto;

    if (grupAntic != grupNou && faFaltaMoure) {
      final id = idAmbQueEsFaLaFoto ?? (idGuardaUsuari != idActual? idGuardaUsuari: idActual) ;
      await ref
          .read(StorageServiceProvider)
          .mouFotoAlumne(grupAntic, grupNou, id);
      faFaltaMoure = true;
    }
  }

  // Guarda l'usuari (crear o editar)
  Future<void> _guardarUsuari() async {
    final formulariValid = _formKey.currentState!.validate();

    if (!formulariValid) return;

    final normalitzat =
        CodiGenerator.normalitzaIdentificador(idController.text);
    setState(() {
      // Si vols reescriure el camp amb el text normalitzat:
      idController.value = idController.value.copyWith(
        text: normalitzat,
        selection: TextSelection.collapsed(offset: normalitzat.length),
      );

      idGuardaUsuari = normalitzat;
    });

    final llistaExistents = isAlumne? await ref.read(studentRepositoryProvider).findAllStudents() : await ref.read(teacherRepositoryProvider).carregaProfessorsDB();

    final idJaExisteix =
    llistaExistents.any((usuari) => usuari.uId == idGuardaUsuari && (usuari.uId == null || usuari.uId != idGuardaUsuari));

    if(idJaExisteix){
      DialogHelper.mostrarSnackBar(context, 'Ja existeix un usuari amb aquest ID.');
      return;
    }

    final usuariNou = crearUsuariGeneric();

    if (foto != null) {
      //Guardem la foto
      final uri = await ref.read(UriProvider.notifier).getUri();
      final guardada = await PlatformChannel.savePhoto(
          uri: uri!,
          id: idGuardaUsuari,
          tipusUsuari: widget.isAlumne ? 'Alumnes' : 'Professors',
          grup: nomCursSeleccionat,
          bytes: foto!);

      if (guardada) {
        usuariNou.hasFoto = true;
        usuariNou.photoPathHash =
            DateTime.now().millisecondsSinceEpoch.toString();
      }

      //Pero haurem d'eliminar l'antiga si el id no és igual
      if (uriImageUser != null && idActual != idGuardaUsuari) {
        await ref.read(StorageServiceProvider).eliminaFoto(uriImageUser!);
        faFaltaMoure = false;
      }
    } else if ((uriImageUser != null) && (idActual != idGuardaUsuari)) {
      //Este cas és quan no s'ha fet una foto nova però sí que s'ha canviat el id, per tant hem de renombrar-la

      final uri = await ref.read(UriProvider.notifier).getUri();

      await PlatformChannel.renameFile(
          uri: uri!,
          uriFoto: uriImageUser!,
          id: idGuardaUsuari,
          grup: cursAmbQueShaFetLaFoto,
          tipusUsuari: widget.isAlumne ? alumnesFolder : professorsFolder);
    }

    String? nomCurs;
    if (usuariNou is Student) {
      int? idCurs;

      final cursTrobat = await ref
          .read(cursosNotifierProvider.notifier)
          .getCursPerNom(nomCursSeleccionat!);

      nomCurs = cursTrobat!.name;
      idCurs = cursTrobat.id;

      //Assignem a l'usuari nou el curs corresponent
      usuariNou.group = nomCurs;
      usuariNou.courseId = idCurs;

      await _moureFotoSiCal(usuariNou, nomCursSeleccionat!);
    }

    Navigator.pop(context, usuariNou);
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

    //nomCursSeleccionat realment no pot ser null
    String? cursFoto;
    if (isAlumne) {
      final cursTrobat = await ref
          .read(cursosNotifierProvider.notifier)
          .getCursPerNom(nomCursSeleccionat!);

      if (cursTrobat != null) {
        cursFoto = cursTrobat.name;
      }
    }

    final uri = await ref.read(UriProvider.notifier).getUri();

    if (uri == null) {
      DialogHelper.mostrarDialogUri(context, true);
      return;
    }

    final result = await Navigator.push<Uint8List?>(
      context,
      MaterialPageRoute(
        builder: (context) => CameraPage(),
      ),
    );

    if (result != null) {
      setState(() {
        foto = result;

        idAmbQueEsFaLaFoto = idController.text;
        cursAmbQueShaFetLaFoto = cursFoto!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(usuari == null ? "Nou usuari" : "Editar usuari"),
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
                validator: (text) => Validator.validarUsuId(
                    idController.text, ref, isAlumne),
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
              if (isAlumne) ...[
                CursosDropdown(
                    cursId: widget.cursId!,
                    onGrupSeleccionat: (nomCurs) {
                      nomCursSeleccionat = nomCurs;
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
                      uri: uriImageUser,
                      bytes: foto,
                      fotoPathHash:
                          //(widget.usuari as Usuari).fotoPathHash!,
                          fotoPathHashAGuardar,
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
