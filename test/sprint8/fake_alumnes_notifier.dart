import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xml_fotos/domain/entities/alumne.dart';
import 'package:xml_fotos/domain/entities/curs.dart';
import 'package:xml_fotos/presentation/providers/alumne_notifier.dart';
import 'package:xml_fotos/presentation/providers/cursos_notifier.dart';

class FakeAlumnesNotifier extends AutoDisposeAsyncNotifier<List<Alumne>> implements AlumnesNotifier {
  final List<Alumne> fakeAlumnes;

  FakeAlumnesNotifier(this.fakeAlumnes);

  @override
  Future<void> actualitza(Alumne usuariActualitzat) {
    // TODO: implement actualitza
    throw UnimplementedError();
  }

  @override
  Future<List<Alumne>> build() {
    // TODO: implement build
    throw UnimplementedError();
  }

  @override
  Future<void> carregarAlumnes() {
    // TODO: implement carregarAlumnes
    throw UnimplementedError();
  }

  @override
  Future<void> editarAlumne(Alumne alumne) {
    // TODO: implement editarAlumne
    throw UnimplementedError();
  }

  @override
  Future<void> editarAlumnes(List<Alumne> alumnes) {
    // TODO: implement editarAlumnes
    throw UnimplementedError();
  }

  @override
  Future<void> eliminarAlumne(Alumne alumne) {
    // TODO: implement eliminarAlumne
    throw UnimplementedError();
  }

  @override
  Future<void> eliminarAlumnes(List<Alumne> alumnes) {
    // TODO: implement eliminarAlumnes
    throw UnimplementedError();
  }

  @override
  Future<bool> existeixNia(String codi) {
    // TODO: implement existeixNia
    throw UnimplementedError();
  }

  @override
  Future<List<Alumne>> getAlumnesPerCurs(int id) {
    // TODO: implement getAlumnesPerCurs
    throw UnimplementedError();
  }

  @override
  Future<List<Alumne>> getAlumnesSenseModificarState() async {
    return fakeAlumnes;
  }

  @override
  Future<void> inserirAlumne(Alumne alumne) {
    // TODO: implement inserirAlumne
    throw UnimplementedError();
  }

  @override
  Future<void> inserirAlumnes(List<Alumne> alumnes) async {
    debugPrintStack(label: 'inserirAlumnes cridada');
  }
}
