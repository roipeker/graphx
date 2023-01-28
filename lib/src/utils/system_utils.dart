import 'package:flutter/foundation.dart';

abstract class SystemUtils {
  static bool get usingSkia {
    if (!kIsWeb) {
      return true;
    }
    return const bool.fromEnvironment('FLUTTER_WEB_USE_SKIA');
  }
}
