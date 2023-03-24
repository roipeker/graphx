/// A collection of static methods for working with strings.
class StringUtils {
  /// Factory constructor to ensure exception. Throws an exception if an attempt
  /// is made to instantiate this class.
  factory StringUtils() {
    throw UnsupportedError(
      "Cannot instantiate StringUtils. Use only static methods.",
    );
  }

  // Private constructor to prevent instantiation
  // StringUtils._();

  /// Parses a string value to become a boolean.
  ///
  /// Returns `true` if the value is equal to 'true', 'TRUE', 'True', or '1'.
  static bool parseBoolean(String value) {
    return value == 'true' ||
        value == 'TRUE' ||
        value == 'True' ||
        value == '1';
  }
}
