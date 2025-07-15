import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xml_fotos/application/services/saf_methods.dart';

import '../../presentation/providers/uri_notifier.dart';
import '../../shared/utils/constants.dart';

final StorageServiceProvider = Provider<StorageService>((ref) {
  return StorageService(ref);
});

class StorageService {
  final Ref ref;

  StorageService(this.ref);

  Future<String> getBaseDirectory() async {
    final dirBase = await ref.read(UriProvider.notifier).getUri();
    if (dirBase == null) {
      throw Exception("No directory selected");
    }
    return dirBase;
  }

  /// Obté el path de la carpeta d’un student concret
  Future<String> getPathAlumne(String nomCurs, String niaAlumne) async {
    final baseDir = await getBaseDirectory();
    return '$baseDir/$alumnesFolder/$nomCurs/$niaAlumne.jpg';
  }

  /// Obté el path de la foto d’un teacher concret
  Future<String> getPathProfessor(String dniProf) async {
    final baseDir = await getBaseDirectory();
    return '$baseDir/$professorsFolder/$dniProf.jpg';
  }

  Future<String> getDirAlumne(String nomCurs, String nomAlumne) async {
    final baseDir = await getBaseDirectory();
    return '$baseDir/$alumnesFolder/$nomCurs';
  }

  /// Obté el path de la foto d’un teacher concret
  Future<String> getDirProfessor(String nomProfessor) async {
    final baseDir = await getBaseDirectory();
    return '$baseDir/$professorsFolder';
  }

  Future<void> eliminaFoto(Uri uri) async {
    final List<Uri> llistaUris = [];
    llistaUris.add(uri);
    await eliminaFotos(llistaUris);
  }

  Future<void> eliminaFotos(List<Uri> uris) async {
    await PlatformChannel.eliminaFotos(uris);
  }

  Future<void> esborraDirIContingut(List<String> paths) async {
    final baseDir = await getBaseDirectory();
    await PlatformChannel.esborraDirIContingut(baseDir, paths);
  }

  Future<void> mouFotoAlumne(String cursVell, String cursNou, String niaAlumne) async {

    //Obtenim la uri de la foto vella
    final uriFotoVella = await PlatformChannel.getFotoAlumneUri(cursVell, niaAlumne);

    //Passem de la uri de la foto vella a Uint8List amb readBytesFromSafUri i aixina obtenim la foto
    final fotoVella = await PlatformChannel.readBytesFromSafUri(uriFotoVella!);

    //Guardem primer la foto a la nova ubi
    final uri = await ref.read(UriProvider.notifier).getUri();
    final guardada = await PlatformChannel.savePhoto(
        uri: uri!, id: niaAlumne, tipusUsuari: "Alumnes", grup: cursNou,bytes: fotoVella!);

    if (guardada){
      await eliminaFoto(uriFotoVella);
    }
  }
}
