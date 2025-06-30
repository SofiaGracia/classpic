import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xml_fotos/application/services/codi_generator.dart';
import 'package:xml_fotos/presentation/providers/uri_notifier.dart';
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
  final String codiUsuari; // Codi identificador (NIA, DNI o generat)

  const NewEditUserScreen({
    super.key,
    required this.usuari,
    required this.getId,
    required this.constructor,
    required this.isAlumne,
    required this.codiUsuari,
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

  String? _imatge; // Ruta de la imatge de l'usuari
  String? _fotoPathHash; // Hash de la foto per invalidació de caché
  String? grupSeleccionat; // Grup seleccionat per a alumnes
  T? usuariActual; // Referència a l'usuari actual
  String? _fotoPathHashAGuardar;

  @override
  void initState() {
    super.initState();

    usuariActual = widget.usuari;
    //_imatge = widget.usuari?.fotoFilename;
    _fotoPathHash = widget.usuari?.fotoPathHash;
    _fotoPathHashAGuardar = _fotoPathHash;

    final usuari = widget.usuari;
    idController = TextEditingController(text: widget.codiUsuari);
    nomController = TextEditingController(text: usuari?.nom ?? '');
    cognom1Controller = TextEditingController(text: usuari?.c1 ?? '');
    cognom2Controller = TextEditingController(text: usuari?.c2 ?? '');
    if (usuari is Alumne) {
      grupSeleccionat = usuari.grup;
      grupSeleccionat ??= grupSensenom;
    }

    //Listener per a idController
    /*idController.addListener(() {
      final text = idController.text.trim();
      try {
        final normalitzat = CodiGenerator.normalitzaId(text);
        setState(() {
          // Si vols reescriure el camp amb el text normalitzat:
          idController.value = idController.value.copyWith(
            text: normalitzat,
            selection: TextSelection.collapsed(offset: normalitzat.length),
          );
        });
      } on FormatException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message)),
        );
      }
    });*/
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
        fotoPathHash: _fotoPathHashAGuardar,
        hasFoto: _imatge == null? false: true
        /*fotoFilename: widget.isAlumne
            ? await ref.read(StorageServiceProvider).getPathAlumne(
                grupSeleccionat ??= grupSensenom, idController.text)
            : await ref
                .read(StorageServiceProvider)
                .getPathProfessor(idController.text),*/
      );

      // Si és alumne, busquem el curs associat al grup seleccionat
      //En principi grupSeleccionat no pot ser mai null
      if (usuariNou is Alumne) {
        int? idCursSeleccionat;
        String? nomCursSeleccionat;

        grupSeleccionat ??= grupSensenom;

        //final cursTrobat = _trobaCurs(cursos as List<Curs>);
        final cursTrobat = await ref
            .read(cursosNotifierProvider.notifier)
            .getCursPerNom(grupSeleccionat!);

        idCursSeleccionat = cursTrobat!.id;
        nomCursSeleccionat = cursTrobat.nom;

        //Assignem a l'usuari nou el curs corresponent
        usuariNou.grup = nomCursSeleccionat;
        usuariNou.cursId = idCursSeleccionat;

        //Se ha canviat de curs
        /*if ((widget.usuari != null) &&
            ((widget.usuari) as Alumne).grup != grupSeleccionat) {
          //Si canviem de lloc la foto...
          /*await ref.read(StorageServiceProvider).mouFotoAlumne(
              (widget.usuari as Alumne).grup!,
              nomCursSeleccionat,
              widget.usuari!.usuId);*/

          //...hi ha que canviar-li el path
          /*usuariNou.fotoFilename = await ref
              .read(StorageServiceProvider)
              .getPathAlumne(nomCursSeleccionat, '$idNormalitzat');*/
          usuariNou.fotoFilename = await ref
              .read(StorageServiceProvider)
              .getPathAlumne(nomCursSeleccionat, idController.text);
        }*/
      }

      //print(usuariNou.fotoFilename);

      // Tornem enrere amb el nou usuari
      Navigator.pop(context, usuariNou);
    }
  }

  // Obre la pantalla de càmera i actualitza la imatge si es fa una foto nova
  Future<void> _gestionaFoto() async {
    if (idController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Has d’omplir ID')),
      );
      return null;
    }
    String? nomCursSeleccionat;

    if (widget.isAlumne && grupSeleccionat != null) {
      final cursTrobat = await ref
          .read(cursosNotifierProvider.notifier)
          .getCursPerNom(grupSeleccionat!);

      if (cursTrobat != null) {
        nomCursSeleccionat = cursTrobat.nom;
      }
    }

    final uri = await ref.read(uriProvider.notifier).getUri();

    final File? novaFoto = await Navigator.push<File?>(
      context,
      MaterialPageRoute(
        builder: (context) => CameraPage(
          uri: uri!,
          id: idController.text,
          tipusUsuari: widget.isAlumne ? 'Alumne' : 'Professor',
          grup: nomCursSeleccionat,
        ),
      ),
    );

    if (novaFoto != null) {
      setState(() {
        _fotoPathHashAGuardar =
            DateTime.now().millisecondsSinceEpoch.toString();
        _imatge = novaFoto.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cursosAsync = widget.isAlumne
        ? ref.watch(cursosNotifierProvider)
        : const AsyncValue.data([]);

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
                    idController.text, ref, widget.isAlumne),
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
                    String? valorInicial;
                    if (widget.cursId != null) {
                      // Comprova que el id estiga a la llista
                      if (cursos.any((c) => c.id == widget.cursId)) {
                        valorInicial = widget.cursId.toString();
                      }
                    }

                    // Si no està en l allista gasta el primer o a null
                    valorInicial ??=
                        cursos.isNotEmpty ? cursos.first.id.toString() : null;

                    // Actualitza grupSeleccionat
                    if (valorInicial != null && grupSeleccionat == null) {
                      grupSeleccionat = cursos
                          .firstWhere((c) => c.id.toString() == valorInicial)
                          .nom;
                    }

                    return DropdownButtonFormField<String>(
                      value: valorInicial,
                      onChanged: (nouId) {
                        if (nouId != null) {
                          final nomDelGrup = cursos
                              .firstWhere((c) => c.id.toString() == nouId)
                              .nom;
                          setState(() {
                            grupSeleccionat = nomDelGrup;
                          });
                        }
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
              const SizedBox(height: 30),
              /*GestureDetector(
                onTap: _gestionaFoto,
                child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey.shade200,
                    child: widget.usuari == null
                        ? const Icon(Icons.person)
                        : _imatge == null
                            ? const Icon(Icons.person)
                            : FutureBuilder<Uri?>(
                                future: widget.isAlumne
                                    ? PlatformChannel.getFotoAlumneUri(ref,
                                        grupSeleccionat!, idController.text)
                                    : PlatformChannel.getFotoProfessorUri(
                                        ref, idController.text),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const CircularProgressIndicator();
                                  }
                                  if (snapshot.hasError) {
                                    return const Icon(Icons.error);
                                  }

                                  final pathPhoto = snapshot.data;

                                  return FotoUsuariWidget(
                                    uri: pathPhoto,
                                    fotoPathHash:
                                        (widget.usuari as Usuari).fotoPathHash!,
                                    radius: 30,
                                  );
                                },
                              )),
              ),*/
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
