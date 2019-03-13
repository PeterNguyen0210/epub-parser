import 'package:archive/archive.dart';

import 'package:epub_parser/src/model/book_ref.dart';
import 'package:epub_parser/src/model/book.dart';
import 'package:epub_parser/src/readers/package_reader.dart';

class EpubReader {
  static Future<BookRef> openBook(List<int> bytes) async {
    Archive archive = new ZipDecoder().decodeBytes(bytes);

    BookRef bookRef = new BookRef();
    bookRef.package = PackageReader.readPackage(archive);
    bookRef.title = bookRef.package.metadata.title;
    bookRef.author = bookRef.package.metadata.creator;

    return bookRef;
  }

  static Future<Book> readBook(List<int> bytes) async {
    BookRef bookRef = await openBook(bytes);
    return null;
  }
}
