import 'dart:ui';

import 'package:flutter/foundation.dart';

/// A class containing utility methods related to system functionality, such as
/// checking if Skia is being used.
class SystemUtils {
  /// Flag indicating whether Skia is being used. On non-web platforms, this is
  /// always true.
  static bool? _usesSkia;

  /// Returns a boolean indicating whether Skia is being used. On non-web
  /// platforms, this method always returns true.
  static bool get usingSkia {
    if (!kIsWeb) {
      return true;
    }
    return _usesSkia ??= _initUsesSkia();
    // return const bool.fromEnvironment('FLUTTER_WEB_USE_SKIA');
  }

  /// Factory constructor to ensure exception. Throws an exception if an attempt
  /// is made to instantiate this class.
  factory SystemUtils() {
    throw UnsupportedError(
      "Cannot instantiate SystemUtils. Use only static methods.",
    );
  }

  // Private constructor to prevent instantiation
  //SystemUtils._();

  /// Initializes and returns the value of [_usesSkia] based on whether Skia can
  /// be used without errors.
  static bool _initUsesSkia() {
    try {
      Path.combine(PathOperation.union, Path(), Path());
      _usesSkia = true;
    } catch (e) {
      _usesSkia = false;
    }
    return _usesSkia!;
  }
}
