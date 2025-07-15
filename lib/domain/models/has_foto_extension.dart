import 'package:xml_fotos/domain/models/user.dart';

import '../../application/services/saf_methods.dart';
import '../entities/alumne.dart';
import '../entities/teacher.dart';

extension UsuariExtensions on User {
  Future<Uri?> get getFotoUri async {
    final uriBase = PlatformChannel.baseUri;
    if (uriBase == null) return null;

    final uri = this is Alumne
        ? await PlatformChannel.getFotoAlumneUri((this as Alumne).grup!, uId)
        : await PlatformChannel.getFotoProfessorUri(uId);

    return uri;
  }
}
