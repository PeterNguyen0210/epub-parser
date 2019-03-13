import 'package:archive/archive.dart';

import 'package:epub_parser/src/model/epub_book_ref.dart';
import 'package:epub_parser/src/model/opf/manifest_item.dart';
import 'package:epub_parser/src/model/opf/meta_item.dart';
import 'package:epub_parser/src/util/path_utils.dart';

class ImageReader {
  static List<int> readCoverImage(EpubBookRef bookRef) {
    try {
      MetaItem coverMetaItem = bookRef.package.metadata.metaItems
          .firstWhere((item) => item.name == "cover", orElse: null);

      ManifestItem coverImageItem = bookRef.package.manifest.items
          .firstWhere((item) => item.id == coverMetaItem.content, orElse: null);

      ArchiveFile file = bookRef.archive.firstWhere((file) =>
          file.name ==
          PathUtils.getContentPath(bookRef.package.packageDirectoryPath, coverImageItem.href));

      return file.content;
    } on Error catch (e) {
      print("Cover Image could not be found");
      return null;
    }
  }
}
