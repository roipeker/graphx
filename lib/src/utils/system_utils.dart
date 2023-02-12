import 'dart:ui';

import 'package:flutter/foundation.dart';

abstract class SystemUtils {
  static bool? _usesSkia;

  static bool _initUsesSkia() {
    try {
      Path.combine(PathOperation.union, Path(), Path());
      _usesSkia = true;
    } catch (e) {
      _usesSkia = false;
    }
    return _usesSkia!;
  }

  static bool get usingSkia {
    if (!kIsWeb) {
      return true;
    }
    return _usesSkia ??= _initUsesSkia();
    // return const bool.fromEnvironment('FLUTTER_WEB_USE_SKIA');
  }
}
