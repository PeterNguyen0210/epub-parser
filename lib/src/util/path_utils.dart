class PathUtils {
  static String getDirectoryPath(String path) {
    var tmp = path.split("/");
    tmp.removeLast();
    return tmp.join("/");
  }

  static String getContentPath(String containerDirectory, String filePath) {
    return (containerDirectory == null || containerDirectory == "")
        ? filePath
        : [containerDirectory, filePath].join("/");
  }
}
