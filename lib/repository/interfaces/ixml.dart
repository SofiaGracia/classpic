import 'package:xml/xml.dart';

abstract class IRepositoryXml {
  Future<XmlDocument?> carregaInfo();
}
