import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xml_fotos/domain/entities/curs.dart';
import 'package:xml_fotos/presentation/providers/cursos_notifier.dart';

class FakeCursosNotifier extends AutoDisposeAsyncNotifier<List<Curs>> implements CursosNotifier {
  final List<Curs> fakeCursos;

  FakeCursosNotifier(this.fakeCursos);

  @override
  Future<List<Curs>> build() async {
    // Retorna la llista fixa sense fer cap acció real
    return fakeCursos;
  }

  // Pots sobreescriure mètodes que facin mutacions si cal,
// o deixar-los buits o llançar errors si no vols que s'utilitzin.

  @override
  Future<Curs?> actualitza(Curs cursActualitzat) {
    // TODO: implement actualitza
    throw UnimplementedError();
  }

  @override
  Future<void> buidarCursos() async {
    debugPrint('buidarCursos() cridat');
  }

  @override
  Future<void> carregarCursos() {
    // TODO: implement carregarCursos
    throw UnimplementedError();
  }

  @override
  Future<bool> checkCurs(Curs curs) {
    // TODO: implement checkCurs
    throw UnimplementedError();
  }

  @override
  Future<void> eliminarCurs(Curs curs) {
    // TODO: implement eliminarCurs
    throw UnimplementedError();
  }

  @override
  Future<void> eliminarCursos(List<Curs> cursos) {
    // TODO: implement eliminarCursos
    throw UnimplementedError();
  }

  @override
  Future<List<Curs>> getCursosSenseModificarState() async {
    // TODO: implement getCursosSenseModificarState
    //throw UnimplementedError();
    return fakeCursos;
  }

  @override
  Future<void> inserirCurs(Curs curs) async {
    // TODO: implement inserirCurs
    throw UnimplementedError();
  }

  @override
  Future<void> inserirCursos(List<Curs> cursos) async {
    // TODO: implement inserirCursos
    //throw UnimplementedError();
    debugPrintStack(label:'inserirCursosFake cridat');
  }
}
