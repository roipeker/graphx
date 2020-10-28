import 'dart:ui';

import 'package:graphx/graphx/geom/gxrect.dart';

class GxTexture {
  Image source;
  GxRect _scaledRect;
  GxRect sourceRect;
  GxTexture base;

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
        source.width.toDouble(),
        source.height.toDouble(),
      );
    }
  }

  GxRect get normalizedRect {
    _scaledRect ??= GxRect();
    _scaledRect.copyFrom(sourceRect);
    _scaledRect /= scale;
    return _scaledRect;
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
