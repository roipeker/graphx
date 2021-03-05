class StringUtils {
  static bool parseBoolean(String value) {
    return value == 'true' ||
        value == 'TRUE' ||
        value == 'True' ||
        value == '1';
  }
}
