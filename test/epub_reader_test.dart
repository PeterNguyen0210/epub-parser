library epubreadertest;

import 'dart:io' as io;

import 'package:path/path.dart' as path;
import 'package:test/test.dart';

import 'package:epub_parser/src/epub_reader.dart';
import 'package:epub_parser/src/model/epub_book_ref.dart';
import 'package:epub_parser/src/model/epub_book.dart';

main() async {
  String fileName = "orwell-animal-farm.epub";
  String fullPath = path.join(io.Directory.current.path, "test", "res", fileName);
  var targetFile = new io.File(fullPath);
  if (!(await targetFile.exists())) {
    throw new Exception("Specified epub file not found: ${fullPath}");
  }

  List<int> bytes = await targetFile.readAsBytes();
  test("Test Epub Ref", () async {
    EpubBookRef epubRef = await EpubReader.openBook(bytes);
  });
  test("Test Epub Read", () async {
    EpubBook epubRef = await EpubReader.readBook(bytes);
  });

  test("Test Epub dasd", () async {
    String a = "a/b/c";
    var b = a.split("/");
    var c = b.removeLast();
    print(b);
  });
}
