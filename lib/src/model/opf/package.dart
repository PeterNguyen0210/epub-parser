import 'package:epub_parser/src/model/opf/manifest.dart';
import 'package:epub_parser/src/model/opf/metadata.dart';
import 'package:epub_parser/src/model/opf/spine.dart';

class Package {
  String packageDirectoryPath;
  Metadata metadata;
  Manifest manifest;
  Spine spine;
}
