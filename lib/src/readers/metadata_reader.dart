import 'package:xml/xml.dart' as xml;

import 'package:epub_parser/src/model/opf/metadata.dart';

class MetadataReader {
  static Metadata readMetadata(xml.XmlDocument packageDocument) {
    Metadata metadata = new Metadata();
    return metadata;
  }
}
