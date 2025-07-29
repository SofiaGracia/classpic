import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:classpic/application/services/saf_methods.dart';
import 'package:classpic/presentation/providers/course/repository.dart';
import 'package:classpic/presentation/providers/student/repository.dart';
import 'package:classpic/presentation/providers/teacher/repository.dart';
import 'package:classpic/shared/utils/dialog/uri.dart';

import '../../shared/utils/constants.dart';
import '../../shared/utils/dialog/delete.dart';

class CheckDirService {
  final Ref ref;

  CheckDirService(this.ref);

  Future<bool?> showDialog(BuildContext context, String message) async {
    final result = await showConfirmacioDialog(
        context: context,
        titol: 'Avís:',
        botoConfirmar: 'Triar directori',
        missatge: message,
        botoCancel: 'Tria un altre directori');
    return result;
  }

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

  Future<bool?> checkDir(BuildContext context, String uriDirBase) async {
    var directoriAmbFotos = false;

    final hasData = await dbHasData();

    //checkear si existeix teacher si sí comprovar si té fotos
    final teacherHasDir =
        await dirHasBasicStructure(uriDirBase, professorsFolder);
    if (teacherHasDir) {
      //comprovar si té fotos
      final teacherHasPhotos =
          await dirHasPhotos(uriDirBase, professorsFolder, null);
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

      if (courses.isEmpty) {
        directoriAmbFotos = await dirHasPhotos(uriDirBase, alumnesFolder, null);
      } else {
        for (final course in courses) {
          List<String> oneCourse = [];
          oneCourse.add(course.name);
          final studentHasPhoto =
              await dirHasPhotos(uriDirBase, alumnesFolder, oneCourse);
          if (studentHasPhoto) {
            directoriAmbFotos = true;
            break;
          }
        }
      }
    }

    if (!hasData && !directoriAmbFotos) {
      DialogHelper.mostrarSnackBar(context, "Directori triat correctament");
      return true;
    }

    if (hasData && !directoriAmbFotos) {
      return await showDialog(context,
          "Inconsistència: hi ha usuaris amb fotos, però no hi ha fotos al directori.");
    }

    if (!hasData && directoriAmbFotos) {
      return await showDialog(context,
          "Inconsistència: hi ha fotos al directori, però cap usuari les té associades.");
    }

    if (hasData && directoriAmbFotos) {
      return await showDialog(context,
          "Possibles inconsistències: comprova que les fotos coincideixen amb els usuaris.");
    }

    DialogHelper.mostrarSnackBar(context, "Error al triar el nou directori");
    return false;
  }
}
