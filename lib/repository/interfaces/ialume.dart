import 'package:xml_fotos/models/alumne.dart';

abstract class IRepositoryAlumne {
  Future<List<Alumne>> carregaLlistaAlumnes();
}
