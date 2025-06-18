import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/services/storage_service.dart';
import '../providers/storage_migration_controller.dart';

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

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(storageMigrationControllerProvider);

    if (state.status == StorageMigrationStatus.loading) {
      return Center(child: CircularProgressIndicator());
    }

    final storage = ref.read(StorageServiceProvider);

    return Column(
      children: [
        RadioListTile(
          title: Text('Carpeta interna de l\'aplicació'),
          value: DirectoriFotos.intern,
          groupValue: seleccioActual,
          onChanged: (value) async {

            //Cridar primer a changeDirectory i segons el procés fer state o no
            setState(() => seleccioActual = value!);
            await storage.guardaDirectoriSeleccionat(value!);
          },
        ),
        RadioListTile(
          title: Text('Pictures/ClassPic'),
          value: DirectoriFotos.pictures,
          groupValue: seleccioActual,
          onChanged: (value) async {
            setState(() => seleccioActual = value!);
            await storage.guardaDirectoriSeleccionat(value!);
          },
        ),
        RadioListTile(
          title: Text('DCIM/ClassPic'),
          value: DirectoriFotos.dcim,
          groupValue: seleccioActual,
          onChanged: (value) async {
            setState(() => seleccioActual = value!);
            await storage.guardaDirectoriSeleccionat(value!);
          },
        ),
      ],
    );
  }
}
