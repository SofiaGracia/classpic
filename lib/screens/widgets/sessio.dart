import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xml_fotos/screens/cicles.dart';
import 'package:xml_fotos/screens/import.dart';

class SessioWidget extends StatefulWidget {
  final String? nomSessio;

  const SessioWidget({super.key, required this.nomSessio});

  @override
  State<SessioWidget> createState() => _SessioWidgetState();
}

class _SessioWidgetState extends State<SessioWidget> {
  @override
  Widget build(BuildContext context) {
    return buildCard(context, widget.nomSessio);
  }

  Widget buildCard(BuildContext context, String? nomSessio) {
    return Container(
      margin: const EdgeInsets.all(7),
      child: InkWell(
        onTap: () {
          // Navegar a una altra pantalla passant-li el nom de la sessió
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => nomSessio == null? ImportScreen(): CiclesScreen(),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.nomSessio ?? 'BUIT',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
