import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xml_fotos/domain/models/user.dart';
import 'package:xml_fotos/presentation/providers/professor_notifier.dart';

import '../../application/services/saf_methods.dart';
import '../../application/services/storage_service.dart';
import '../../domain/entities/alumne.dart';
import '../../domain/entities/curs.dart';
import '../../domain/entities/teacher.dart';
import '../providers/alumne_notifier.dart';
import '../providers/stream_providers.dart';
import '../widgets/new_user.dart';
import '../widgets/usuari_riverpod_ind.dart';

class LlistaUsuarisStream<T extends User> extends ConsumerWidget {
  final bool isAlumne;
  final Curs? curs;

  const LlistaUsuarisStream({
    super.key,
    required this.isAlumne,
    required this.curs
});

  String _getTitol(){
    return isAlumne? 'Alumnes de ${curs!.nom}': 'Professors';
  }

  Future<List<T>> _carregaLlista<T extends User>(
      WidgetRef ref, bool isAlumne, int? cursId) {
    if (isAlumne) {
      return ref
          .read(alumnesNotifierProvider.notifier)
          .getAlumnesPerCurs(cursId!) as Future<List<T>>;
    } else {
      return ref
          .read(professorNotifierProvider.notifier)
          .getProfessorsSenseModificarState() as Future<List<T>>;
    }
  }

  Widget _buildScaffold(WidgetRef? ref, Widget fill) {
    return Scaffold(
      appBar: AppBar(
        title: Text((_getTitol())),
      ),
      body: fill,
      floatingActionButton: ref == null ? null : NewUserR<User>(
        onCreate: (u) async {
          if (u is Alumne) {
            await ref.read(alumnesNotifierProvider.notifier).inserirAlumne(u);
          } else {
            await ref.read(professorNotifierProvider.notifier).inserirProfessor(u as Teacher);
          }
        },
        cursId: isAlumne? curs!.id! : null,
        getId: (u) => isAlumne ? (u as Alumne).nia : (u as Teacher).dni,
        isAlumne: isAlumne,
      ),
    );
  }

  Widget _buildLlista(BuildContext context, WidgetRef ref, List<T> llista) {
    return llista.isEmpty? Text('No hi ha usuaris'): ListView(
      children: llista.map((usuari) {
        return UsuariWidgetRInd(
          usuari: usuari,
          onDelete: (u) async {
            if (u is Alumne) {
              await ref.read(alumnesNotifierProvider.notifier).eliminarAlumne(u);
              if (u.hasFoto){
                final uriAlumne = await PlatformChannel.getFotoAlumneUri(u.grup!, u.nia);
                await ref.read(StorageServiceProvider).eliminaFoto(uriAlumne!);
              }
            } else {
              await ref.read(professorNotifierProvider.notifier).eliminarProfessor(u as Teacher);
              if (u.hasFoto){
                final uriProf = await PlatformChannel.getFotoProfessorUri(u.dni);
                await ref.read(StorageServiceProvider).eliminaFoto(uriProf!);
              }
            }
          },
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //Llegir el stream d'ids del provider d'ids
    final idsAsync = ref.watch(professorsIdsStreamProvider);

    return idsAsync.when(
      data: (ids) => Text('IDs: Tenim ids'),
      loading: () => const CircularProgressIndicator(),
      error: (e, stack) => Text('Error: $e'),
    );

    /*return idsAsync.when(
      data: (ids) {
        //Otindre la llista de Professors o Alumnes(filtrats) no ids
        //I construir un ListView amb UsuarisWidgetInd
        return FutureBuilder<List<T>>(
          future: _carregaLlista<T>(ref, isAlumne, curs?.id),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Scaffold(
                appBar: AppBar(
                  title: Text(_getTitol()),
                ),
                body:const Center(child: CircularProgressIndicator()),
              );
            }
            final novaLlista = snapshot.data!;

            //Ací cridem a que construeixca un widget amb esta llista
            final fill = _buildLlista(context, ref, novaLlista);
            return _buildScaffold(ref, fill);
          },
        );
      },
      loading: () {
        //Construirem el Scaffold però li passarem un CircularProgressIndicator
        final fill = const CircularProgressIndicator();
        return _buildScaffold(ref, fill);
      },
      error: (e, _) {
        //Construirem el Scaffold però li passarem el text de l'error
        final fill = Text('error $e');
        return _buildScaffold(null, fill);
      },
    );*/
  }
}