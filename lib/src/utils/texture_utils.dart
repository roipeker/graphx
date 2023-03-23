import 'dart:ui' as ui;

import '../../graphx.dart';

/// Collection of utility methods for creating and manipulating [GTextures].
///
mixin GTextureUtils {
  /// Helper shape to draw shapes and create textures.
  static final GShape _helperShape = GShape();

  /// The resolution used for [GTexture] creation in this class.
  static double resolution = 1.0;

  /// Helper method to get the graphics object of [_helperShape].
  static Graphics get _g {
    return _helperShape.graphics;
  }

  /// Creates a circular [GTexture] with the given parameters.
  ///
  /// The [color] parameter specifies the fill color of the circle, and the
  /// [radius] parameter specifies the radius of the circle.
  ///
  /// The [x] and [y] parameters specify the coordinates of the center of the
  /// circle.
  ///
  /// The optional [id] parameter specifies an identifier for the created
  /// texture, which can be used to retrieve the texture from the texture cache
  /// later.
  static GTexture createCircle({
    ui.Color color = kColorMagenta,
    double radius = 20,
    double x = 0,
    double y = 0,
    String? id,
  }) {
    _g.clear().beginFill(color).drawCircle(x, y, radius);
    return _drawShape(id);
  }

  /// Creates a rectangle [GTexture] with the given parameters.
  ///
  /// The [color] parameter sets the fill color of the rectangle.
  /// The [x] and [y] parameters specify the top-left corner of the rectangle.
  /// The [w] and [h] parameters specify the width and height of the rectangle.
  /// The [id] parameter, if provided, sets an identifier for the resulting
  /// [GTexture], which can be used to cache the texture in
  /// [ResourceLoader.textureCache].
  static GTexture createRect({
    ui.Color color = kColorMagenta,
    double x = 0,
    double y = 0,
    double w = 20,
    double h = 20,
    String? id,
  }) {
    _g.clear().beginFill(color).drawRect(x, y, w, h);
    return _drawShape(id);
  }

  /// Creates a rounded rectangle [GTexture] with the given parameters. The
  /// [color] parameter defines the fill color of the rectangle. The [x] and [y]
  /// parameters define the position of the top-left corner of the rectangle.
  /// The [w] and [h] parameters define the width and height of the rectangle,
  /// respectively. The [r] parameter defines the radius of the rectangle's
  /// corners. The optional [id] parameter can be used to cache the resulting
  /// texture under a specific ID in the texture cache.
  static GTexture createRoundRect({
    ui.Color color = kColorMagenta,
    double x = 0,
    double y = 0,
    double w = 20,
    double h = 20,
    double r = 8,
    String? id,
  }) {
    _g.clear().beginFill(color).drawRoundRect(x, y, w, h, r).endFill();
    return _drawShape(id);
  }

  /// Creates a triangle [GTexture] with the given parameters.
  ///
  /// The triangle will be filled with the provided [color]. The [w] and [h]
  /// parameters define the width and height of the bounding box of the
  /// triangle. The [rotation] parameter specifies the rotation of the triangle
  /// in degrees clockwise.
  ///
  /// If an [id] is provided, the resulting [GTexture] will be added to the
  /// [ResourceLoader]'s texture cache with that ID.
  static GTexture createTriangle({
    ui.Color color = kColorMagenta,
    double w = 20,
    double h = 20,
    double rotation = 0,
    String? id,
  }) {
    _g
        .clear()
        .beginFill(color)
        .drawPolygonFaces(0, 0, w / 2, 3, rotation)
        .endFill();
    var heightScale = h / w;
    _helperShape.scaleY = heightScale;
    var tx = _drawShape(id);
    _helperShape.scaleY = 1;
    return tx;
  }

  /// Returns the nearest valid texture size for a given [size].
  /// This is done by comparing the previous and next valid texture sizes,
  /// and returning the one that is closest to the input size.
  static int getNearestValidTextureSize(int size) {
    final prev = getPreviousValidTextureSize(size);
    final next = getNextValidTextureSize(size);
    return size - prev < next - size ? prev : next;
  }

  /// Returns the next valid power of 2 texture size for a given [size]. For
  /// example, if the given size is 100, this function returns 128, which is the
  /// next power of 2 after 100. The returned size is always a power of 2.
  static int getNextValidTextureSize(int size) {
    var newSize = 1;
    while (size > newSize) {
      newSize *= 2;
    }
    return newSize;
  }

  /// Returns the largest valid texture size smaller than [size], which is a
  /// power of 2. If [size] is already a power of 2, the result is the next power
  /// of 2 that is smaller than [size].
  static int getPreviousValidTextureSize(int size) {
    return getNextValidTextureSize(size) >> 1;
  }

  /// A utility method to create a list of rectangular [GTexture]s from a given
  /// [base] texture, by dividing it into smaller rectangles of size [w] x [h].
  ///
  /// The [padding] argument can be used to add padding between the sub-textures.
  ///
  /// The [scale] argument can be used to modify the scale of the created
  /// sub-textures.
  static List<GTexture> getRectAtlasFromGTexture(
    GTexture base,
    int w, {
    int? h,
    int padding = 0,
    double scale = 1,
  }) {
    h ??= w;

    /// create SubTextures from the main Texture.
    var cols = base.sourceRect!.width / w;
    var rows = base.sourceRect!.height / h;
    var total = cols * rows;
    var output = <GTexture>[];
    final textureW = w.toDouble();
    final textureH = h.toDouble();
    for (var i = 0; i < total; ++i) {
      final px = (i % cols) * textureW;
      final py = (i ~/ cols) * textureH;
      var subRect = GRect(px, py, textureW, textureH);
      var texture = GSubTexture(
        base,
        region: subRect,
        scaleModifier: scale,
        rotated: false,
      );
      output.add(texture);
    }
    return output;
  }

  /// Checks if a texture [size] is valid (i.e., a power of 2).
  /// Returns true if the [size] is valid, false otherwise.
  static bool isValidTextureSize(int size) {
    return getNextValidTextureSize(size) == size;
  }

  /// Sets the scale-9-grid of a given [GTexture] based on [x], [y], [w], and [h]
  /// parameters. If [adjustScale] is true, the values will be multiplied by
  /// the texture's scale factor.
  static void scale9Rect(
    GTexture tx,
    double x, {
    double? y,
    double? w,
    double? h,
    bool adjustScale = false,
  }) {
    y ??= x;
    w ??= -x;
    h ??= -y;
    if (adjustScale) {
      x *= tx.scale!;
      y *= tx.scale!;
      w *= tx.scale!;
      h *= tx.scale!;
    }
    if (w < 0) {
      w = tx.width! + w * 2;
    }
    if (h < 0) {
      h = tx.height! + h * 2;
    }
    var out = GRect(x, y, w, h);
    tx.scale9Grid = out;
  }

  /// Helper method to create a [GTexture] from the [_helperShape].
  static GTexture _drawShape([String? id]) {
    final tx = _helperShape.createImageTextureSync(
      true,
      GTextureUtils.resolution,
    );
    if (id != null) {
      ResourceLoader.textureCache[id] = tx;
    }
    return tx;
  }
}
