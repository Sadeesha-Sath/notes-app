class ContentTrimmer {
  static int length = 45;

  static String? trimmer(String? text, [int? customLength]) {
    if (text != null) {
      if (text.length <= (customLength ?? length)) {
        return text;
      }
      return text.substring(0, customLength ?? length) + "...";
    }
    return null;
  }
}
