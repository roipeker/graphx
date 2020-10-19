import 'dart:ui';

class GTexture {
  Image source;
  Rect sourceRect;

  /// adjustment rect.
  Rect spriteRect;
  double anchorX = 0;
  double anchorY = 0;
  double scale = 1;

  /// Flag for atlas rendering... when supported.
  bool isSubTexture = false;
  GTexture(
    this.source, [
    this.sourceRect,
    this.isSubTexture = false,
    this.scale = 1,
  ]) {
    if (sourceRect == null && source != null) {
      sourceRect = Rect.fromLTWH(
        0,
        0,
        source.width.toDouble() * scale,
        source.height.toDouble() * scale,
      );
    }
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
}
