import 'dart:ui';

import 'package:graphx/graphx/geom/gxrect.dart';

class GxTexture {
  Image source;
  GxRect sourceRect;

  /// adjustment rect.
  GxRect spriteRect;
  double anchorX = 0;
  double anchorY = 0;
  double scale = 1;

  /// Flag for atlas rendering... when supported.
  bool isSubTexture = false;

  GxTexture(
    this.source, [
    this.sourceRect,
    this.isSubTexture = false,
    this.scale = 1,
  ]) {
    if (sourceRect == null && source != null) {
      sourceRect ??= GxRect();
      sourceRect.setTo(
        0,
        0,
        source.width.toDouble() * scale,
        source.width.toDouble() * scale,
      );
    }
  }

  GxRect get normalizedRect {
    return sourceRect /= scale;
  }

  int get width {
    return sourceRect?.width?.toInt() ?? source.width;
  }

  int get height {
    return sourceRect?.height?.toInt() ?? source.height;
  }

  void dispose() {
    source?.dispose();
    spriteRect = null;
    sourceRect = null;
    source = null;
  }

  @override
  String toString() {
    return 'GTexture {source: $source, sourceRect: $sourceRect, scale: $scale, isSubTexture: $isSubTexture}';
  }
}
