class PathUtils {
  static String getDirectoryPath(String path) {
    var tmp = path.split("/");
    tmp.removeLast();
    return tmp.join("/");
  }
}
