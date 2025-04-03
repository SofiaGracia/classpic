import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xml_fotos/repository/sessio.dart';
import 'package:xml_fotos/screens/cicles.dart';
import 'package:xml_fotos/screens/widgets/sessio.dart';

import '../models/sessio.dart';
import 'import.dart';

class SessioScreen extends StatefulWidget {
  const SessioScreen({super.key});

  @override
  State<SessioScreen> createState() => _SessioScreenState();
}

class _SessioScreenState extends State<SessioScreen> {
  final SessioRepository _sessioRepository = SessioRepository();
  List<Sessio> _sessioList = [];

  @override
  void initState() {
    super.initState();
    _loadSessioList();
  }

  void _loadSessioList() async {
    final sessiolist = await _sessioRepository.loadListSession();
    setState(() {
      _sessioList = sessiolist;
    });
  }

  void saludar(){
    debugPrint('Hola');
  }

  void _crearSessio() async {
    // Crear la nova sessió
    Sessio novaSessio = await _sessioRepository.crearSessio();

    // Afegir-la a la llista i actualitzar la UI
    setState(() {
      _sessioList.add(novaSessio);
    });
  }

  void _borrarSessio(Sessio sessio) async {
    await _sessioRepository.borrarSessio(sessio);

    setState(() {
      _sessioList.remove(sessio);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sessions de treball', style: Theme.of(context).textTheme.titleLarge,),
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