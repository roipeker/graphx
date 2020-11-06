class StringUtils {
  static bool parseBoolean(String value) {
    if (value == null) return null;
    return value == 'true' ||
        value == 'TRUE' ||
        value == 'True' ||
        value == '1';
  }
}
