// test/fakes/fake_repository_cursos.dart

import 'package:xml_fotos/repository/interfaces/ixml.dart';

class FakeRepositoryCursos implements IRepositoryCursos {
  @override
  Future<List<String>> carregaInfo() async {
    return ['DAM', 'DAW', 'ASIX'];
  }
}
