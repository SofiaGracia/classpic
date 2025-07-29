import 'package:classpic/domain/models/qualitat_foto.dart';

class Resolucio {
  final int amplada;
  final int alcada;

  Resolucio(this.amplada, this.alcada);
}


extension ResolucioExtensio on QualitatFoto {
  Resolucio get resolucio {
    switch (this) {
      case QualitatFoto.baixa:
        return Resolucio(640, 480);
      case QualitatFoto.mitjana:
        return Resolucio(1024, 768);
      case QualitatFoto.alta:
        return Resolucio(1600, 1200);
    }
  }

  String get nom {
    switch (this) {
      case QualitatFoto.baixa:
        return 'Baixa (640x480)';
      case QualitatFoto.mitjana:
        return 'Mitjana (1024x768)';
      case QualitatFoto.alta:
        return 'Alta (1600x1200)';
    }
  }
}

Resolucio resolucioPerQualitat(QualitatFoto qualitat) {
  switch (qualitat) {
    case QualitatFoto.baixa:
      return Resolucio(640, 480);
    case QualitatFoto.mitjana:
      return Resolucio(1024, 768);
    case QualitatFoto.alta:
      return Resolucio(1600, 1200);
  }
}
