import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xml/xml.dart';
import 'package:xml_fotos/application/services/storage_service.dart';

import '../../presentation/providers/professor_notifier.dart';
import '../../data/datasources/xml/professor_xml.dart';

class ProfessorImportHandler{
  final Ref ref;
  final StorageService storage;

  ProfessorImportHandler(this.ref, this.storage);

  Future<void> processa(XmlDocument doc) async {
    final profNot = ref.read(professorNotifierProvider.notifier);
    final professorsDB = await ref.watch(professorsTotsProvider.future);
    final professorsXml = await RepositoryProfessorXml(doc: doc).carregaLlistaProfessorsXml();

    if (professorsDB.isEmpty) {
      await storage.creaEstructuraProfessors();
      await profNot.inserirProfessors(professorsXml);
    } else {

      final profDBSet = professorsDB.map((e) => e.dni).toSet();
      final pAfegir = professorsXml.where((p) => !profDBSet.contains(p.dni)).toList();
      final pEliminar = professorsDB.where((p) => !professorsXml.any((px) => px.dni == p.dni)).toList();

      if (pAfegir.isNotEmpty) await profNot.inserirProfessors(pAfegir);
      if (pEliminar.isNotEmpty){
        List<String> fotoPaths = [];
        for(final p in pEliminar){
          if(p.fotoPath != null){
            fotoPaths.add(p.fotoPath!);
          }
        }
        await storage.eliminaFotos(fotoPaths);
        await profNot.eliminarProfessors(pEliminar);
      }
    }
  }
}