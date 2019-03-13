import 'package:archive/archive.dart';

import 'package:epub_parser/src/model/epub_book_ref.dart';
import 'package:epub_parser/src/model/opf/manifest_item.dart';
import 'package:epub_parser/src/model/opf/meta_item.dart';

class ImageReader {
  static List<int> readCoverImage(EpubBookRef bookRef) {
    try {
      MetaItem coverMetaItem = bookRef.package.metadata.metaItems
          .firstWhere((item) => item.name == "cover", orElse: null);

      ManifestItem coverImageItem = bookRef.package.manifest.items
          .firstWhere((item) => item.id == coverMetaItem.content, orElse: null);

      ArchiveFile file = bookRef.archive.firstWhere((file) =>
          file.name == [bookRef.package.packageDirectoryPath, coverImageItem.href].join("/"));

      return file.content;
    } on Exception catch (e) {
      print("Cover Image could not be found");
      return null;
    }
  }
}
