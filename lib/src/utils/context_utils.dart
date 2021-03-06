import 'package:flutter/widgets.dart';

import '../../graphx.dart';

abstract class ContextUtils {
  /// todo: validate RenderObject Type.
  static GRect? getRenderObjectBounds(BuildContext context) {
    trace(context);
    final box = context.findRenderObject() as RenderBox;
    return GRect.fromNative(box.localToGlobal(Offset.zero) & box.size);
  }
}
