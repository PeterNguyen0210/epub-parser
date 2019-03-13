import 'package:archive/archive.dart';
import 'package:epub_parser/src/model/opf/content_type.dart';
import 'package:epub_parser/src/model/opf/manifest_item_ref.dart';
import 'package:epub_parser/src/model/opf/meta_item.dart';
import 'package:epub_parser/src/util/path_utils.dart';
import 'package:xml/xml.dart' as xml;
import 'dart:convert';

import 'package:epub_parser/src/model/opf/package.dart';
import 'package:epub_parser/src/model/opf/metadata.dart';
import 'package:epub_parser/src/model/opf/manifest.dart';
import 'package:epub_parser/src/model/opf/manifest_item.dart';
import 'package:epub_parser/src/model/opf/spine.dart';

class PackageReader {
  static Package readPackage(Archive archive) {
    Package package = new Package();
    xml.XmlDocument packageDocument = xml.parse(_getPackageFile(archive));

    package.packageDirectoryPath = PathUtils.getDirectoryPath(getPackageFilePath(archive));
    package.metadata = _readMetadata(packageDocument);
    package.manifest = _readManifest(packageDocument);
    package.spine = _readSpine(packageDocument);

    return package;
  }

  static String getPackageFilePath(Archive archive) {
    final CONTAINER_FILE_PATH = "META-INF/container.xml";
    var containerFile = archive.firstWhere((file) => file.name == CONTAINER_FILE_PATH);

    if (containerFile == null) {
      throw new Exception(
          "Parsing Error. Container Unable to find container file at $CONTAINER_FILE_PATH");
    }

    var containerDocument = xml.parse(utf8.decode(containerFile.content));
    var packageFilePath =
        containerDocument.findAllElements("rootfile").first.getAttribute("full-path");

    return packageFilePath;
  }

  static String _getPackageFile(Archive archive) {
    String packageFilePath = getPackageFilePath(archive);
    var packageFile = archive.firstWhere((file) => file.name == packageFilePath);

    if (packageFile == null) {
      throw Exception("Parsing Error. Unable to find package file at $packageFilePath");
    }

    return utf8.decode(packageFile.content);
  }

  static Metadata _readMetadata(xml.XmlDocument packageDocument) {
    Metadata metadata = new Metadata();
    xml.XmlElement metadataElement = packageDocument.findAllElements("metadata").first;

    metadata.identifier = metadataElement.findElements("dc:identifier").first.text;
    metadata.title = metadataElement.findElements("dc:title").first.text;
    metadata.language = metadataElement.findElements("dc:language").first.text;
    metadata.creator = metadataElement.findElements("dc:creator").first.text;
    metadata.date = metadataElement.findElements("dc:date").first.text;
    metadata.publisher = metadataElement.findElements("dc:publisher").first.text;
    metadata.rights = metadataElement.findElements("dc:rights").first.text;
    metadata.subject = metadataElement.findElements("dc:subject").first.text;
    metadata.metaItems = _readMetaItems(metadataElement);

    return metadata;
  }

  static List<MetaItem> _readMetaItems(xml.XmlElement metadataElement) {
    List<MetaItem> metaItems = new List<MetaItem>();

    metadataElement.findElements("meta").forEach((item) {
      MetaItem mItem = new MetaItem();
      mItem.id = item.getAttribute("id");
      mItem.property = item.getAttribute("property");
      mItem.content = item.getAttribute("content");
      mItem.name = item.getAttribute("name");

      metaItems.add(mItem);
    });

    return metaItems;
  }

  static Manifest _readManifest(xml.XmlDocument packageDocument) {
    Manifest manifest = new Manifest();
    manifest.items = new List<ManifestItem>();

    xml.XmlElement manifestElement = packageDocument.findAllElements("manifest").first;
    manifestElement.findElements("item").forEach((item) {
      ManifestItem manifestItem = new ManifestItem();
      manifestItem.id = item.getAttribute("id");
      manifestItem.href = item.getAttribute("href");
      manifestItem.mediaType = _getContentType(item.getAttribute("media-type"));

      manifest.items.add(manifestItem);
    });

    return manifest;
  }

  static Spine _readSpine(xml.XmlDocument packageDocument) {
    Spine spine = new Spine();
    spine.itemRef = new List<ManifestItemRef>();

    xml.XmlElement spineElement = packageDocument.findAllElements("spine").first;
    spineElement.findElements("itemref").forEach((item) {
      ManifestItemRef manifestItemRef = new ManifestItemRef();
      manifestItemRef.id = item.getAttribute("idref");
      manifestItemRef.linear = item.getAttribute("linear");

      spine.itemRef.add(manifestItemRef);
    });
    return spine;
  }

  static ContentType _getContentType(String mediaType) {
    switch (mediaType) {
      case "application/xhtml+xml":
        return ContentType.XHTML_XML;
        break;
      case "text/css":
        return ContentType.CSS;
        break;
      case "image/jpeg":
        return ContentType.IMAGE_JPEG;
        break;
      default:
        return ContentType.UNKNOWN;
    }
  }
}
