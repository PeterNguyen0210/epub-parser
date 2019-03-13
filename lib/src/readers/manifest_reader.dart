import 'package:xml/xml.dart' as xml;

import 'package:epub_parser/src/model/opf/manifest.dart';

class ManifestReader {
  static Manifest readManifest(xml.XmlDocument packageDocument) {
    Manifest manifest = new Manifest();
    return manifest;
  }
}
