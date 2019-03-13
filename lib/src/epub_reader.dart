import 'package:archive/archive.dart';

import 'package:epub_parser/src/model/epub_book_ref.dart';
import 'package:epub_parser/src/model/epub_book.dart';
import 'package:epub_parser/src/readers/content_reader.dart';
import 'package:epub_parser/src/readers/image_reader.dart';
import 'package:epub_parser/src/readers/package_reader.dart';

class EpubReader {
  static Future<EpubBookRef> openBook(List<int> bytes) async {
    Archive archive = new ZipDecoder().decodeBytes(bytes);

    EpubBookRef bookRef = new EpubBookRef();
    bookRef.archive = archive;
    bookRef.package = PackageReader.readPackage(archive);
    bookRef.title = bookRef.package.metadata.title;
    bookRef.author = bookRef.package.metadata.creator;
    bookRef.coverImage = ImageReader.readCoverImage(bookRef);
    return bookRef;
  }

  static Future<EpubBook> readBook(List<int> bytes) async {
    EpubBook book = new EpubBook();
    EpubBookRef bookRef = await openBook(bytes);

    book.content = ContentReader.readContent(bookRef);
    return null;
  }
}
