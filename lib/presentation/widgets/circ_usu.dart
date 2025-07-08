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

enum CicleUserStates { none, waiting, charged}

class CicleUser extends ConsumerStatefulWidget {
  final Usuari usuari;
  final Future<void> Function(Usuari usu) onUpdate;

  const CicleUser({super.key, required this.usuari, required this.onUpdate});

  @override
  ConsumerState<CicleUser> createState() => _CicleUserState();
}

class _CicleUserState extends ConsumerState<CicleUser> {
  late Usuari usuari;
  Uri? fotoUri;
  late CicleUserStates _state;

  @override
  void initState() {
    super.initState();
    usuari = widget.usuari;
    _state = CicleUserStates.waiting;
    _carregaFoto();
  }

  Future<void> _obriCamera(BuildContext context) async {
    try {
      final uri = await ref.read(UriProvider.notifier).getUri();
      if (uri == null) throw DirectoriBaseNoTriat();

      final resultat = await Navigator.push<Uint8List?>(
        context,
        MaterialPageRoute(builder: (_) => const CameraPage()),
      );

      if (resultat == null) return;

      final guardada = await PlatformChannel.savePhoto(
        uri: uri,
        id: usuari.usuId,
        tipusUsuari: usuari is Alumne ? 'Alumnes' : 'Professors',
        grup: usuari is Alumne ? (usuari as Alumne).grup : null,
        bytes: resultat,
      );

      if (guardada == true) {
        await _carregaFoto(); // Tornem a carregar
      }
    } catch (e) {
      if (e is DirectoriBaseNoTriat) {
        showDialog(
          context: context,
          builder: (_) => const UriDialog(navigates: true),
        );
      }
    }
  }

  Future<void> _carregaFoto() async {
    setState(() {
      _state = CicleUserStates.waiting;
    });

    final uri = await usuari.getFotoUri;

    setState(() {
      fotoUri = uri;
      _state = uri == null ? CicleUserStates.none : CicleUserStates.charged;
    });

    final actualitzat = usuari is Alumne
        ? (usuari as Alumne).copyWith(
      hasFoto: uri != null,
      fotoPathHash: DateTime.now().millisecondsSinceEpoch.toString(),
    )
        : (usuari as Professor).copyWith(
      hasFoto: uri != null,
      fotoPathHash: DateTime.now().millisecondsSinceEpoch.toString(),
    );

    await widget.onUpdate(actualitzat);
  }

  @override
  Widget build(BuildContext context) {
    Widget fill;

    switch (_state) {
      case CicleUserStates.none:
        fill = const Icon(Icons.person, size: 30);
        break;
      case CicleUserStates.waiting:
        fill = const SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        );
        break;
      case CicleUserStates.charged:
        if (fotoUri == null) {
          fill = const Icon(Icons.person, size: 20);
        } else {
          fill = FotoUsuariWidget(
            uri: fotoUri!,
            bytes: null,
            fotoPathHash: widget.usuari.fotoPathHash!,
            radius: 30,
          );
        }
        break;
    }

    return GestureDetector(
      onTap: () => _obriCamera(context),
      child: CircleAvatar(
        radius: 30,
        backgroundColor: Colors.grey.shade200,
        child: fill,
      ),
    );
  }
}
