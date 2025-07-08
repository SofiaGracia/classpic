import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xml_fotos/domain/models/has_foto_extension.dart';
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
  Uri? fotoUri;

  @override
  void initState() {
    super.initState();
    usuari = widget.usuari;
    _carregaFoto();
  }

  Future<void> _obriCamera(BuildContext context) async {
    try {
      final uri = await ref.read(UriProvider.notifier).getUri();
      if (uri == null) throw DirectoriBaseNoTriat();

      final resultat = await Navigator.push<Uint8List?>(
        context,
        MaterialPageRoute(
          builder: (context) => CameraPage(),
        ),
      );

      if (resultat == null) {
        return;
      }

      final guardada = await PlatformChannel.savePhoto(
          uri: uri,
          id: widget.usuari.usuId,
          tipusUsuari: widget.usuari is Alumne ? 'Alumnes' : 'Professors',
          grup: widget.usuari is Alumne ? (widget.usuari as Alumne).grup : null,
          bytes: resultat);

      if (guardada == true) {
        _carregaFoto();
      }
    } catch (e) {
      if (e is DirectoriBaseNoTriat) {
        showDialog(
            context: context, builder: (_) => UriDialog(navigates: true));
      }
    }
  }

  Future<void> _carregaFoto() async {
    final uri = await usuari.getFotoUri;

    setState(() {
      fotoUri = uri;
    });

    final actualitzat = usuari is Alumne
        ? (usuari as Alumne).copyWith(hasFoto: uri != null,fotoPathHash: DateTime.now().millisecondsSinceEpoch.toString())
        : (usuari as Professor).copyWith(hasFoto: uri != null, fotoPathHash: DateTime.now().millisecondsSinceEpoch.toString());

    await widget.onUpdate(actualitzat);
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
          child: fotoUri == null
              ? const Icon(Icons.person)
              : FotoUsuariWidget(
                  uri: fotoUri!,
                  bytes: null,
                  fotoPathHash: widget.usuari.fotoPathHash!,
                  radius: 30,
                )),
    );
  }
}
