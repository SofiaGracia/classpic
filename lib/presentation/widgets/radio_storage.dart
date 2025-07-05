import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/services/storage_service.dart';
import '../providers/storage_migration_controller.dart';
/*
class RadioStorage extends ConsumerStatefulWidget {
  final DirectoriFotos seleccio;

  const RadioStorage({super.key, required this.seleccio});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RadioStorageState();
}

class _RadioStorageState extends ConsumerState<RadioStorage> {
  late DirectoriFotos seleccioActual;

  @override
  void initState() {
    super.initState();
    seleccioActual = widget.seleccio;
  }

  Future<void> _onChanged(DirectoriFotos nouDirectori) async {
    final storageController = ref.read(storageMigrationControllerProvider.notifier);
    final resposta = await storageController.changeDirectory(context, nouDirectori);
    if (resposta) {
      setState(() => seleccioActual = nouDirectori);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(storageMigrationControllerProvider);

    //Sols controlem que el loading
    if (state.status == StorageMigrationStatus.loading) {
      return Column(
        children: [
          Center(
            child: CircularProgressIndicator(),
          )

        ],
      );
    }

    return Column(
      children: [
        RadioListTile(
          title: Text('Carpeta interna de l\'aplicació'),
          value: DirectoriFotos.intern,
          groupValue: seleccioActual,
          onChanged: (_) => _onChanged(DirectoriFotos.intern),
        ),
        RadioListTile(
          title: Text('Pictures/ClassPic'),
          value: DirectoriFotos.pictures,
          groupValue: seleccioActual,
          onChanged: (_) => _onChanged(DirectoriFotos.pictures),
        ),
        RadioListTile(
          title: Text('DCIM/ClassPic'),
          value: DirectoriFotos.dcim,
          groupValue: seleccioActual,
          onChanged: (_) => _onChanged(DirectoriFotos.dcim),
        ),
      ],
    );
  }
}*/
