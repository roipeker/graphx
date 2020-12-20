import 'package:flutter/widgets.dart';

import '../../graphx.dart';

abstract class ContextUtils {
  /// todo: validate RenderObject Type.
  static GxRect getRenderObjectBounds(BuildContext context) {
    final box = context.findRenderObject() as RenderBox;
    return GxRect.fromNative(box.localToGlobal(Offset.zero) & box.size);
  }
}
