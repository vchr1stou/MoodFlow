class TextUtils {
  /// Removes markdown formatting from text
  /// This includes characters like *, _, `, #, etc.
  static String removeMarkdown(String text) {
    return text
        .replaceAllMapped(RegExp(r'[*_`#~>|[\](){}]'), (match) => '')
        .replaceAll(RegExp(r'\n{2,}'), '\n'); // collapse extra newlines if needed
  }
} 