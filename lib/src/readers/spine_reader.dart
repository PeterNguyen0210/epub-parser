import 'package:xml/xml.dart' as xml;

import 'package:epub_parser/src/model/opf/spine.dart';

class SpineReader {
  static Spine readSpine(xml.XmlDocument packageDocument) {
    Spine spine = new Spine();
    return spine;
  }
}
