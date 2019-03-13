import 'package:archive/archive.dart';
import 'package:xml/xml.dart' as xml;
import 'dart:convert';

import 'package:epub_parser/src/model/opf/package.dart';
import 'package:epub_parser/src/readers/metadata_reader.dart';
import 'package:epub_parser/src/readers/manifest_reader.dart';
import 'package:epub_parser/src/readers/spine_reader.dart';

class PackageReader {
  static Package readPackage(Archive archive) {
    Package package = new Package();
    xml.XmlDocument packageDocument = xml.parse(_getPackageFile(archive));

    package.metadata = MetadataReader.readMetadata(packageDocument);
    package.manifest = ManifestReader.readManifest(packageDocument);
    package.spine = SpineReader.readSpine(packageDocument);

    return package;
  }

  static String _getPackageFile(Archive archive) {
    final CONTAINER_FILE_PATH = "META-INF/container.xml";
    var containerFile = archive.firstWhere((file) => file.name == CONTAINER_FILE_PATH);

    if (containerFile == null) {
      throw new Exception(
          "Parsing Error. Container Unable to find container file at $CONTAINER_FILE_PATH");
    }

    var containerDocument = xml.parse(utf8.decode(containerFile.content));
    var packageFilePath =
        containerDocument.findAllElements("rootfile").first.getAttribute("full-path");

    var packageFile = archive.firstWhere((file) => file.name == packageFilePath);

    if (packageFile == null) {
      throw Exception("Parsing Error. Unable to find package file at $packageFilePath");
    }

    return utf8.decode(packageFile.content);
  }
}
