import 'package:xml_fotos/domain/models/usuari.dart';

import '../../application/services/saf_methods.dart';
import '../entities/alumne.dart';
import '../entities/professor.dart';

extension UsuariExtensions on Usuari {
  Future<Uri?> get getFotoUri async {
    final uriBase = PlatformChannel.baseUri;
    if (uriBase == null) return null;

    final uri = this is Alumne
        ? await PlatformChannel.getFotoAlumneUri((this as Alumne).grup!, usuId)
        : await PlatformChannel.getFotoProfessorUri(usuId);

    return uri;
  }
}
