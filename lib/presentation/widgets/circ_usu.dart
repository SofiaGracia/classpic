import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xml_fotos/domain/models/usuari.dart';
import 'package:xml_fotos/presentation/widgets/uri_dialog.dart';

import '../../application/services/saf_methods.dart';
import '../../domain/entities/alumne.dart';
import '../../domain/entities/professor.dart';
import '../../domain/errors/import.dart';
import '../providers/uri_notifier.dart';
import '../screens/camera_camera.dart';
import 'foto_usuari.dart';

class CicleUser extends ConsumerStatefulWidget {

  final Usuari usuari;
  final Future<void> Function(Usuari usu) onUpdate;

  const CicleUser({super.key, required this.usuari, required this.onUpdate});

  @override
  ConsumerState<CicleUser> createState() => _CircleUserState();
}

class _CircleUserState extends ConsumerState<CicleUser> {

  late Usuari usuari;

  @override
  void initState() {
    super.initState();
    usuari = widget.usuari;
  }

  Future<void> _obriCamera(BuildContext context) async {
    try {
      final uri = await ref.read(uriProvider.notifier).getUri();
      print(uri);
      if (uri == null) throw DirectoriBaseNoTriat();

      /*final guardada = await Navigator.push<bool?>(
        context,
        MaterialPageRoute(
          builder: (context) => CameraPage(
            uri: uri,
            id: widget.usuari.usuId,
            tipusUsuari: widget.usuari is Alumne ? 'Alumnes' : 'Professors',
            grup: widget.usuari is Alumne ? (widget.usuari as Alumne).grup : null,
          ),
        ),
      );*/
      final resultat = await Navigator.push<Uint8List?>(
        context,
        MaterialPageRoute(
          builder: (context) => CameraPage(
          ),
        ),
      );

      if (resultat == null) {
        return;
      }

      final guardada = await PlatformChannel.savePhoto(uri: uri, id: widget.usuari.usuId, tipusUsuari: widget.usuari is Alumne ? 'Alumnes' : 'Professors' , grup: widget.usuari is Alumne ? (widget.usuari as Alumne).grup : null, bytes: resultat);

      if (guardada == true) {
        final actualitzat = widget.usuari is Alumne
            ? (widget.usuari as Alumne).copyWith(
          fotoPathHash: DateTime.now().millisecondsSinceEpoch.toString(),
          hasFoto: true
        )
            : (widget.usuari as Professor).copyWith(
          fotoPathHash: DateTime.now().millisecondsSinceEpoch.toString(),
            hasFoto: true
        );

        await widget.onUpdate(actualitzat);
      }
    } catch (e) {
      if (e is DirectoriBaseNoTriat) {
        showDialog(context: context, builder: (_) => UriDialog(navigates: true));
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () async {
        _obriCamera(context);
      },
      child: CircleAvatar(
          radius: 30,
          backgroundColor: Colors.grey.shade200,
          child: FutureBuilder<Uri?>(
            future: widget.usuari is Alumne
                ? PlatformChannel.getFotoAlumneUri(
                (widget.usuari as Alumne).grup!,
                widget.usuari.usuId)
                : PlatformChannel.getFotoProfessorUri(
                widget.usuari.usuId),
            builder: (context, snapshot) {
              if (snapshot.connectionState ==
                  ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              if (snapshot.hasError) {
                return const Icon(Icons.error);
              }

              final path = snapshot.data;

              if (path == null) {
                return const Icon(Icons.person);
              }

              return FotoUsuariWidget(
                uri: path,
                bytes: null,
                fotoPathHash: usuari.fotoPathHash!,
                radius: 30,
              );
            },
          )),
    );
  }
}