import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xml_fotos/repository/sessio.dart';
import 'package:xml_fotos/screens/widgets/sessio.dart';

import '../models/sessio.dart';

class SessioScreen extends StatefulWidget {
  final SessioRepository? repository;

  const SessioScreen({super.key, this.repository});

  @override
  State<SessioScreen> createState() => _SessioScreenState();
}

class _SessioScreenState extends State<SessioScreen> {
  late final SessioRepository _sessioRepository;
  List<Sessio> _sessioList = [];
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _sessioRepository = widget.repository ?? SessioRepository.defaultRepo();
    _loadSessioList();
  }

  void mostrarErrorSnackBar(String missatgeError) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(missatgeError),
        backgroundColor: Colors.red, // Color del fons de l'SnackBar
      ),
    );
  }

  void _loadSessioList() async {
    try {
      final sessiolist = await _sessioRepository.loadListSession();
      setState(() {
        _sessioList = sessiolist;
      });
    } catch (e) {
      mostrarErrorSnackBar('Error al carregar les sessions: $e');
    }
  }

  void _crearSessio() async {
    try {
      // Crear la nova sessió
      Sessio novaSessio = await _sessioRepository.crearSessio();

      // Afegir-la a la llista i actualitzar la UI
      setState(() {
        _sessioList.add(novaSessio);
      });

      //throw Exception('Error al carregar la sessió');

    } catch (e) {
      mostrarErrorSnackBar('Error al crear la sessió: $e');
    }
  }

  void _borrarSessio(Sessio sessio) async {
    try {
      // Crear la nova sessió
      await _sessioRepository.borrarSessio(sessio);

      // Afegir-la a la llista i actualitzar la UI
      setState(() {
        _sessioList.remove(sessio);
      });
    } catch (e) {
      mostrarErrorSnackBar('Error al eliminar la sessió: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sessions de treball',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 150),
            child: _sessioList.isEmpty
                ? Center(
                    child: Text(
                      "No hi ha cap sessió disponible",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _sessioList.length,
                    itemBuilder: (context, index) {
                      return SessioWidget(
                        sessio: _sessioList[index],
                        onSessioDeleted: _borrarSessio,
                      );
                    },
                  ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Card(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
              ),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _crearSessio,
                        child: const Text('Crear una nova sessió'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
