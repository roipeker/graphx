import 'package:flutter/widgets.dart';

import '../../graphx.dart';

/// A utility class for handling [BuildContext] related operations.
class ContextUtils {
  // Private constructor to prevent instantiation
  // ContextUtils._();

  /// Factory constructor to ensure exception.
  factory ContextUtils() {
    throw UnsupportedError(
      "Cannot instantiate ContextUtils. Use only static methods.",
    );
  }

  /// Returns the bounds of the [RenderBox] associated with the given [context].
  ///
  /// If the [context] does not have a [RenderBox] associated with it, null is
  /// returned.
  static GRect? getRenderObjectBounds(BuildContext context) {
    // TODO: validate RenderObject Type.
    final box = context.findRenderObject() as RenderBox;
    return GRect.fromNative(box.localToGlobal(Offset.zero) & box.size);
  }
}
