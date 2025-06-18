
class FotoInfo {
  final String folder;   // Ex: 'Professors', 'Alumnes', ...
  final String filename; // Ex: '123456.jpg'

  FotoInfo({
    required this.folder,
    required this.filename,
  });

  /// Crea el path complet a partir del basePath que li passes
  /// Exemple: basePath='/storage/emulated/0/Pictures/ClassPic'
  String buildFullPath(String basePath) {
    return '$basePath/$folder/$filename';
  }
}
