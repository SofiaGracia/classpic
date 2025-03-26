import 'dart:io';

class Carpeta {
  final String tipus;
  final String modalitat;
  final String grup;
  final String basePath;

  Carpeta({
    required this.tipus,
    required this.modalitat,
    required this.grup,
    required this.basePath,
  });

  String get path => '$basePath/$tipus/$modalitat/$grup';

  Future<void> crearDirectori() async {
    final dir = Directory(path);
    if (!await dir.exists()) {
      await dir.create(recursive: true);
      print("Directori creat: $path");
    }
  }
}