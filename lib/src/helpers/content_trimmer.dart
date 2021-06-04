class ContentTrimmer {
  // TODO Find the right length
  static int length = 50;

  static String? trimTitle(String? title) {
    if (title != null) {
      
      if (title.length <= length) {
        return title;
      }
      return title.substring(0, length) + "...";
    }
    return null;
  }

  static String? trimBody(String? body) {
    if (body != null) {
      if (body.length <= length) {
        return body;
      }
      return body.substring(0, length) + "...";
    }
    return null;
  }
}
