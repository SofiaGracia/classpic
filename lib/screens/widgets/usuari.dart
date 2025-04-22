import 'dart:typed_data';
import 'package:flutter/material.dart';

class UsuariTile extends StatelessWidget {
  final String primerCognom;
  final String segonCognom;
  final String nom;
  final String identificador; // DNI o NIA
  final Uint8List? foto; // Nullable per si no té foto
  final VoidCallback onEditar;
  final VoidCallback onEliminar;

  const UsuariTile({
    super.key,
    required this.primerCognom,
    required this.segonCognom,
    required this.nom,
    required this.identificador,
    this.foto,
    required this.onEditar,
    required this.onEliminar,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            // Foto de l'usuari
            CircleAvatar(
              radius: 30,
              backgroundImage: foto != null ? MemoryImage(foto!) : null,
              child: foto == null ? const Icon(Icons.person) : null,
            ),
            const SizedBox(width: 12),

            // Dades del usuari
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$primerCognom $segonCognom',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    nom,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    identificador,
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ],
              ),
            ),

            // Botons acció
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: onEditar,
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onEliminar,
            ),
          ],
        ),
      ),
    );
  }
}
