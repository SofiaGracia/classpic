import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xml_fotos/screens/cicles.dart';
import 'package:xml_fotos/screens/import.dart';

import '../../models/sessio.dart';
import '../../repository/sessio.dart';

class SessioWidget extends StatefulWidget {

  final Function(Sessio sessio) onSessioDeleted;
  final Sessio sessio;

  const SessioWidget({super.key, required this.sessio, required this.onSessioDeleted});

  @override
  State<SessioWidget> createState() => _SessioWidgetState();
}

class _SessioWidgetState extends State<SessioWidget> {

  SessioRepository sessioRepository = SessioRepository();

  @override
  Widget build(BuildContext context) {
    return buildCard(context, widget.sessio);
  }

  void actualitzarSessio(Sessio sessio, String nomFitxerXmlTrobat){
    setState(() {
      sessio.nomFitxerXml = nomFitxerXmlTrobat;
    });
    //Despres d'açò el que vull és que pose a l'arxiu .json en nom el nom de l'arxiu
    sessioRepository.guardarMetadades(sessio);
  }

  void saludar(){
    debugPrint('Hola');
  }

  Widget buildCard(BuildContext context, Sessio sessio) {
    return Container(
      margin: const EdgeInsets.all(7),
      child: InkWell(
        onTap: () {
          // Navegar a una altra pantalla passant-li el nom de la sessió
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => sessio.nomFitxerXml == null? ImportScreen(sessio: sessio, onFileFound: actualitzarSessio,): CiclesScreen(),
            ),
          );
        },
        borderRadius: BorderRadius.circular(10), // Per a fer efecte de feedback
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'DATA: ${sessio.dataString}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        'Fitxer xml: ${sessio.nomFitxerXml ?? 'BUIT'}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: IconButton(
                  onPressed: () => widget.onSessioDeleted(sessio),
                  icon: const Icon(Icons.delete, color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
