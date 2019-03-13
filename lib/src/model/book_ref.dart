import 'package:archive/archive.dart';

import 'package:epub_parser/src/model/opf/package.dart';

class BookRef {
  Archive archive;
  Package package;
  String title;
  String author;
  List<int> coverImage;
}
