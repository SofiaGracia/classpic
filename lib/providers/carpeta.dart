import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import '../models/carpeta.dart';
import '../models/grup.dart';
import 'info_xml.dart';
import '../repository/cursos.dart';

class CarpetaProvider extends ChangeNotifier {
  final Map<String, Carpeta> _carpetes = {};

  CarpetaProvider() {
    _inicialitzarEstructura();
  }

  /// Inicialitza l'estructura de carpetes
  Future<void> _inicialitzarEstructura() async {

    final directory = await getExternalStorageDirectory();
    final basePath = directory?.path ?? "/storage/emulated/0/MyApp";
    final baseDir = Directory(basePath);

    if (await baseDir.exists()) {

      final tipusDirs = baseDir.listSync().whereType<Directory>();

      if(tipusDirs.isNotEmpty){
        debugPrint("📂 L'estructura de carpetes ja existeix. Carregant...");
        debugPrint("ruta: $basePath");
        await _carregarCarpetes(baseDir);
      }else {
        debugPrint("📂 Creant estructura de carpetes...");
        debugPrint("ruta: $basePath");
        await baseDir.create(recursive: true);
        await crearCarpetes(basePath);
      }
    }
  }

  /// Crea l'estructura de carpetes a partir de cursos
  Future<void> crearCarpetes(String basePath) async {
    Map<String, Map<String, Set<Grup>>> cursos =  await RepositoryCursosXML.carregaInfo();

    final baseDir = Directory(basePath);
    if (!await baseDir.exists()) await baseDir.create(recursive: true);

    for (var tipus in cursos.keys) {
      final tipusDir = Directory('$basePath/$tipus');
      if (!(await tipusDir.exists())) await tipusDir.create();

      for (var modalitat in cursos[tipus]!.keys) {
        final modalitatDir = Directory('${tipusDir.path}/$modalitat');
        if (!(await modalitatDir.exists())) await modalitatDir.create();

        for (var grup in cursos[tipus]![modalitat]!) {
          await afegirCarpeta(tipus, modalitat, grup.nom, basePath);
        }
      }
    }
  }

  /// Afegeix una nova carpeta al mapa `_carpetes`
  Future<void> afegirCarpeta(String tipus, String modalitat, String grup, String basePath) async {

    print(tipus);
    print(modalitat);
    print(grup);

    final carpetaPath = '$basePath/$tipus/$modalitat/$grup';
    final carpetaDir = Directory(carpetaPath);

    if (!await carpetaDir.exists()) {
      await carpetaDir.create(recursive: true);
      print("🆕 Carpeta creada: $carpetaPath");
    } else {
      print("⚠️ La carpeta ja existeix: $carpetaPath");
    }

    String clau_carpeta = '$tipus$modalitat$grup';

    _carpetes[clau_carpeta] = Carpeta(
      tipus: tipus,
      modalitat: modalitat,
      grup: grup,
      basePath: basePath,
    );

    notifyListeners();
  }

  /// Carrega carpetes existents
  Future<void> _carregarCarpetes(Directory baseDir) async {

    final tipusDirs = baseDir.listSync().whereType<Directory>();
    print('Tamany de tipusDirs: ${tipusDirs.length}');

    for (var tipusDir in tipusDirs) {
      final tipus = tipusDir.uri.pathSegments[tipusDir.uri.pathSegments.length - 2];

      final modalitatDirs = tipusDir.listSync().whereType<Directory>();
      print('Tamany de modalitatDirs: ${modalitatDirs.length}');
      for (var modalitatDir in modalitatDirs) {
        final modalitat = modalitatDir.uri.pathSegments[modalitatDir.uri.pathSegments.length - 2];

        final grupDirs = modalitatDir.listSync().whereType<Directory>();
        print('Tamany de grupDirs: ${grupDirs.length}');
        for (var grupDir in grupDirs) {
          final grup = grupDir.uri.pathSegments[grupDir.uri.pathSegments.length - 2];

          print(tipus);
          print(modalitat);
          print(grup);

          String clau_carpeta = '$tipus$modalitat$grup';

          _carpetes[clau_carpeta] = Carpeta(
            tipus: tipus,
            modalitat: modalitat,
            grup: grup,
            basePath: baseDir.path,
          );
        }
      }
    }

    notifyListeners();
    print("✅ Carpetes carregades correctament.");
  }

  /// Retorna totes les carpetes creades
  Map<String, Carpeta> obtenirTotes() {
    return _carpetes;
  }

  //No fem control de si es nul
  Carpeta? obtenirCarpeta(String tipus, String modalitat, String grup) {

    //print(tipus);
    //print(modalitat);
    //print(grup);


    //debugPrint('Tamany de _carpetes: ${_carpetes.length}');

    _carpetes.forEach((clau, carpeta) {
      print('Clau: $clau -> Tipus: ${carpeta.tipus}, Modalitat: ${carpeta.modalitat}, Grup: ${carpeta.grup}');
    });

    String carpeta_a_buscar = '$tipus$modalitat$grup';

    return _carpetes[carpeta_a_buscar];

    /*return _carpetes.values.firstWhere(
          (carpeta) => carpeta.tipus == tipus && carpeta.modalitat == modalitat && carpeta.grup == grup,
    );*/
  }
}
