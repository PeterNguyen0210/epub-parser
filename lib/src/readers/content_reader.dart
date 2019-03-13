import 'dart:convert';
import 'package:archive/src/archive.dart';

import 'package:epub_parser/src/model/content/book_content.dart';
import 'package:epub_parser/src/model/epub_book_ref.dart';
import 'package:epub_parser/src/model/opf/content_type.dart';

class ContentReader {
  static BookContent readContent(EpubBookRef bookRef) {
    BookContent content = new BookContent();

    content.htmlContent = _readHTMLContent(bookRef);
    content.cssContent = _readCSSContent(bookRef);
    content.imageContent = _readImageContent(bookRef);
    return null;
  }

  static Map<String, String> _readHTMLContent(EpubBookRef bookRef) {
    Map<String, String> htmlContent = new Map<String, String>();
    bookRef.package.manifest.items.forEach((item) {
      if ([ContentType.HTML, ContentType.XHTML_XML].contains(item.mediaType)) {
        htmlContent[item.href] = readTextContent(
            bookRef.archive, [bookRef.package.packageDirectoryPath, item.href].join("/"));
      }
    });

    return htmlContent;
  }

  static Map<String, String> _readCSSContent(EpubBookRef bookRef) {
    Map<String, String> cssContent = new Map<String, String>();
    bookRef.package.manifest.items.forEach((item) {
      if ([ContentType.CSS].contains(item.mediaType)) {
        cssContent[item.href] = readTextContent(
            bookRef.archive, [bookRef.package.packageDirectoryPath, item.href].join("/"));
      }
    });

    return cssContent;
  }

  static Map<String, List<int>> _readImageContent(EpubBookRef bookRef) {
    Map<String, List<int>> imageContent = new Map<String, List<int>>();
    bookRef.package.manifest.items.forEach((item) {
      if ([ContentType.CSS].contains(item.mediaType)) {
        imageContent[item.href] = readImageContent(
            bookRef.archive, [bookRef.package.packageDirectoryPath, item.href].join("/"));
      }
    });

    return imageContent;
  }

  static String readTextContent(Archive archive, String href) {
    print(href);
    return utf8.decode(archive.firstWhere((file) => file.name == href).content);
  }

  static List<int> readImageContent(Archive archive, String href) {
    return archive.firstWhere((file) => file.name == href).content;
  }
}
