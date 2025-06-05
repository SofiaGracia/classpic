import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xml_fotos/application/services/codi_generator.dart';
import '../../domain/entities/alumne.dart';
import '../../domain/entities/curs.dart';
import '../../domain/models/fotopathcacheext.dart';
import '../../domain/models/usuari.dart';
import '../providers/alumne_notifier.dart';
import '../providers/cursos_notifier.dart';
import '../../application/services/storage_service.dart';
import '../../shared/utils/constants.dart';
import '../../shared/utils/validator.dart';
import '../providers/professor_notifier.dart';
import '../widgets/foto_usuari.dart';
import 'camera_camera.dart';

// Aquesta pantalla permet crear o editar un usuari (alumne o professor)
class NewEditUserScreen<T extends Usuari> extends ConsumerStatefulWidget {
  final T? usuari; // Usuari a editar, null si és un nou usuari
  final String Function(T) getId; // Funció per obtenir l'ID del tipus T
  final T Function(
          {required String id,
          required String nom,
          required String c1,
          required String c2,
          String? fotoPath,
          String? fotoPathHash,
          String? grup})
      constructor; // Constructor per crear una instància del tipus T
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

  @override
  void initState() {
    super.initState();

    usuariActual = widget.usuari;
    _imatge = widget.usuari?.fotoPath;
    _fotoPathHash = widget.usuari?.fotoPathHash ??
        DateTime.now().millisecondsSinceEpoch.toString();

    final usuari = widget.usuari;
    idController = TextEditingController(text: widget.codiUsuari);
    nomController = TextEditingController(text: usuari?.nom ?? '');
    cognom1Controller = TextEditingController(text: usuari?.c1 ?? '');
    cognom2Controller = TextEditingController(text: usuari?.c2 ?? '');
    if (usuari is Alumne) {
      grupSeleccionat = usuari.grup;
      grupSeleccionat ??= grupSensenom;
    }
  }

  // Funció per normalitzar l'identificador
  String _normalitzaId(String idInput) {
    //Per al nia
    if (idInput.length == numNia) {
      return CodiGenerator.normalitzaIdentificador(idInput);
    }

    //Per al dni
    if (idInput.length == numDni) {
      return CodiGenerator.normalitzaIdentificador(idInput);
    }

    //Per si és l'id generat per defecte
    if (idInput.length == 10) {
      return idInput;
    }

    throw FormatException('L\'ID ha de tenir entre $numNia i 10 caràcters.');
  }

  // Guarda l'usuari (crear o editar)
  Future<void> _guardarUsuari() async {
    if (_formKey.currentState!.validate()) {
      final idNou = idController.text.trim();
      final idAntic = widget.usuari?.usuId;

      // Només fem la comprovació si és un usuari nou o si canvia l'id
      final idHaCanviat = idAntic == null || idNou != idAntic;

      //Ací és on faria la comprovació de si id es de 9 o de 10 caràcters
      final idNormalitzat;
      try {
        idNormalitzat = _normalitzaId(idNou);
      } on FormatException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message)),
        );
        return;
      }

      // Comprovem si ja existeix aquest ID en la llista d'usuaris
      if (idHaCanviat) {
        final llistaExistents = widget.isAlumne
            ? ref.read(alumnesNotifierProvider).maybeWhen(
                  data: (alumnes) => alumnes,
                  orElse: () => [],
                )
            : ref.read(professorNotifierProvider).maybeWhen(
                  data: (professors) => professors,
                  orElse: () => [],
                );

        final idJaExisteix =
            llistaExistents.any((usuari) => usuari.usuId == idNormalitzat);

        if (idJaExisteix) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Ja existeix un usuari amb aquest ID.')),
          );
          return; // Aturem la funció aquí
        }
      }

      int? idCursSeleccionat;
      String? nomCursSeleccionat;

      grupSeleccionat ??= grupSensenom;

      // Si és alumne, busquem el curs associat al grup seleccionat
      if (widget.isAlumne && grupSeleccionat != null) {
        final cursos = ref.read(cursosNotifierProvider).maybeWhen(
              data: (cursos) => cursos,
              orElse: () => [], //Ací tenim un orElse
            );

        final cursTrobat = _trobaCurs(cursos as List<Curs>);

        if (cursTrobat != null) {
          idCursSeleccionat = cursTrobat.id;
          nomCursSeleccionat = cursTrobat.nom;

          // Si ha canviat de grup, movem la seva foto
          if (widget.usuari != null && grupSeleccionat != cursTrobat) {
            await ref.read(StorageServiceProvider).mouFotoAlumne(
                (widget.usuari as Alumne).grup!,
                nomCursSeleccionat,
                widget.usuari!.usuId);
          }
        }
      }

      // Creem la nova instància d'usuari
      final usuariNou = widget.constructor(
        id: idNormalitzat,
        nom: nomController.text.trim(),
        c1: cognom1Controller.text.trim(),
        c2: cognom2Controller.text.trim(),
        fotoPath: _imatge,
        fotoPathHash: _fotoPathHash,
        grup: nomCursSeleccionat,
      );

      // Si és alumne, li assignem el curs i actualitzem la ruta de la foto
      if (usuariNou is Alumne) {
        usuariNou.cursId = idCursSeleccionat;
        if (widget.usuari != null && _imatge != null) {
          usuariNou.fotoPath = await ref
              .read(StorageServiceProvider)
              .getPathAlumne(nomCursSeleccionat!, '$idNormalitzat');
          usuariNou.fotoPathHash =
              DateTime.now().millisecondsSinceEpoch.toString();
        }
      }

      // Tornem enrere amb el nou usuari
      Navigator.pop(context, usuariNou);
    }
  }

  // Troba el curs segons el nom del grup seleccionat
  Curs? _trobaCurs(List<Curs> cursos) {
    for (Curs curs in cursos) {
      if (curs.nom == grupSeleccionat) {
        return curs;
      }
    }
    return null;
  }

  // Obté les rutes per guardar la foto
  Future<Map<String, String>?> getPaths() async {
    if (idController.text.trim().isEmpty ||
        nomController.text.trim().isEmpty ||
        cognom1Controller.text.trim().isEmpty ||
        cognom2Controller.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Has d’omplir ID, Nom, Primer i Segon Cognom')),
      );
      return null;
    }
    String? nomCursSeleccionat;

    if (widget.isAlumne && grupSeleccionat != null) {
      final cursos = ref.read(cursosNotifierProvider).maybeWhen(
            data: (cursos) => cursos,
            orElse: () => [],
          );

      final cursTrobat = _trobaCurs(cursos as List<Curs>);
      if (cursTrobat != null) {
        nomCursSeleccionat = cursTrobat.nom;
      }
    }

    String pathPhoto = '';
    String pathDir = '';
    if (widget.isAlumne) {
      pathPhoto = await ref
          .read(StorageServiceProvider)
          .getPathAlumne(nomCursSeleccionat!, idController.text);
      pathDir = '$baseFolderName/$alumnesFolder/$nomCursSeleccionat';
    } else {
      pathPhoto = await ref
          .read(StorageServiceProvider)
          .getPathProfessor(nomController.text); //Canviar a id
      pathDir = '$baseFolderName/$professorsFolder';
    }
    return {'foto': pathPhoto, 'dir': pathDir};
  }

  // Obre la pantalla de càmera i actualitza la imatge si es fa una foto nova
  Future<void> _gestionaFoto() async {
    final paths = await getPaths();

    if (paths != null) {
      String pathPhoto = paths['foto']!;
      String pathDir = paths['dir']!;

      final File? novaFoto = await Navigator.push<File?>(
        context,
        MaterialPageRoute(
          builder: (context) => CameraPage(
            pathPhoto: pathPhoto,
            pathDir: pathDir,
          ),
        ),
      );

      if (novaFoto != null) {
        setState(() {
          _imatge = novaFoto.path;
          _fotoPathHash = DateTime.now().millisecondsSinceEpoch.toString();
        });
      }
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
                    final valorInicial = curs != null
                        ? curs.id.toString()
                        : cursos.first.id.toString();
                    return DropdownButtonFormField<String>(
                      value: grupSeleccionat == null ? null : valorInicial,
                      onChanged: (nouId) {
                        final nomDelGrup = cursos
                            .firstWhere((c) => c.id.toString() == nouId)
                            .nom;
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
              const SizedBox(height: 30),
              GestureDetector(
                onTap: _gestionaFoto,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey.shade200,
                  child: _imatge == null
                      ? const Icon(Icons.camera_alt,
                          size: 40, color: Colors.white70)
                      : FotoUsuariWidget(
                          fotoPath: _imatge,
                          fotoPathHash: _fotoPathHash!,
                          radius: 50,
                        ),
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
