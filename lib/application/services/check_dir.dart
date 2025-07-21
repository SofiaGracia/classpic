import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xml_fotos/application/services/saf_methods.dart';
import 'package:xml_fotos/presentation/providers/course/repository.dart';
import 'package:xml_fotos/presentation/providers/student/repository.dart';
import 'package:xml_fotos/presentation/providers/teacher/repository.dart';

import '../../presentation/providers/uri_notifier.dart';
import '../../shared/utils/constants.dart';

class CheckDirService {
  final Ref ref;

  CheckDirService(this.ref);

  Future<bool> dbHasData() async {
    final students =
        await ref.read(studentRepositoryProvider).findAllStudents();
    final teachers =
        await ref.read(teacherRepositoryProvider).carregaProfessorsDB();

    final allUsers = [...students, ...teachers];

    return allUsers.any((user) => user.hasFoto);
  }

  Future<bool> dirHasBasicStructure(String? uriDirBase, String folder) async {
    return await PlatformChannel.checkBaseDirExists(
        uri: uriDirBase!, folder: folder);
  }

  Future<bool> dirHasPhotos(
      String uri, String user, List<String>? groups) async {
    return await PlatformChannel.checkFolderHasPhotos(
        uri: uri, tipusUsuari: user, grups: groups);
  }

  Future<String?> checkDir() async {
    var directoriAmbFotos = false;

    final hasData = await dbHasData();

    final uriDirBase = await ref.read(UriProvider.notifier).getUri();

    //checkear si existeix teacher si sí comprovar si té fotos
    final teacherHasDir =
        await dirHasBasicStructure(uriDirBase, professorsFolder);
    if (teacherHasDir) {
      //comprovar si té fotos
      final teacherHasPhotos =
          await dirHasPhotos(uriDirBase!, professorsFolder, null);
      if (teacherHasPhotos) {
        directoriAmbFotos = true;
      }
    }

    //checkear si existeix alumnes si sí comprovar si té grups
    final studentsHasDir =
        await dirHasBasicStructure(uriDirBase, alumnesFolder);
    if (studentsHasDir) {
      final courses =
          await ref.read(courseRepositoryProvider).carregarCursosDB();

      for (final course in courses) {
        List<String> oneCourse = [];
        oneCourse.add(course.name);
        final studentHasPhoto =
            await dirHasPhotos(uriDirBase!, alumnesFolder, oneCourse);

        if (studentHasPhoto) {
          directoriAmbFotos = true;
          break;
        }
      }
    }

    if (!hasData && !directoriAmbFotos) {
      return "✅ Tot correcte. No hi ha dades ni fotos.";
    }

    if (hasData && !directoriAmbFotos) {
      return "⚠️ Inconsistència: hi ha usuaris amb fotos, però no hi ha fotos al directori.";
    }

    if (!hasData && directoriAmbFotos) {
      return "⚠️ Inconsistència: hi ha fotos al directori, però cap usuari les té associades.";
    }

    if (hasData && directoriAmbFotos) {
      return "⚠️ Possibles inconsistències: comprova que les fotos coincideixen amb els usuaris.";
    }
  }
}
