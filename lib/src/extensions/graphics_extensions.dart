import 'dart:ui';

import '../../graphx.dart';

/// Extension class for the [Paint] class, with added functionality.
extension ExtSkiaPaintCustom on Paint {
  /// Returns a new instance of [Paint] created by cloning this instance.
  Paint clone([Paint? out]) {
    out ??= Paint();
    out.maskFilter = maskFilter;
    out.blendMode = blendMode;
    out.color = color;
    out.style = style;
    out.colorFilter = colorFilter;
    out.filterQuality = filterQuality;
    out.imageFilter = imageFilter;
    out.invertColors = invertColors;
    out.isAntiAlias = isAntiAlias;
    out.shader = shader;
    out.strokeCap = strokeCap;
    out.strokeJoin = strokeJoin;
    if (SystemUtils.usingSkia) {
      out.strokeMiterLimit = strokeMiterLimit;
    }
    out.strokeWidth = strokeWidth;
    return out;
  }
}
