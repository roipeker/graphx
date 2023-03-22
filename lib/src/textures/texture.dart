import 'dart:ui' as ui;

import '../../graphx.dart';

/// Represents a 2D texture or image that can be used for rendering.
class GTexture {
  /// The default content scale factor for all GTextures created when the
  /// argument [scale] is less than 0 on texture's initialization.
  static double contentScaleFactor = 1;

  /// (Internal usage)
  /// The default paint used to render the texture.
  static ui.Paint $defaultPaint = ui.Paint();

  /// The region of the texture to render.
  GRect? frame;

  /// The region of the texture that should be scaled when rendering.
  GRect? scale9Grid;

  /// The destination region of the texture to be scaled when rendering.
  GRect? scale9GridDest;

  /// The color of the texture when the texture is a plain color.
  ui.Color? color;

  /// The actual width of the texture after applying the scale.
  double? actualWidth;

  /// The actual height of the texture after applying the scale.
  double? actualHeight;

  /// The horizontal coordinate of the texture's pivot point.
  double? pivotX = 0;

  /// The vertical coordinate of the texture's pivot point.
  double? pivotY = 0;

  /// The source rectangle of the texture.
  GRect? sourceRect;

  /// The scale of the texture.
  double? scale = 1;

  /// The underlying platform [Image] data for the texture.
  ui.Image? root;

  /// Flag that tells if the [GTexture] instance has been disposed.
  var _disposed = false;

  /// Indicates whether this [GTexture] instance has been disposed or not. Once
  /// disposed, the [root] reference and all other properties are set to null,
  /// and further method calls to this instance may result in errors or
  /// unexpected behavior.
  bool get disposed {
    return _disposed;
  }

  /// The height of the frame of the texture.
  double get frameHeight {
    return frame?.height ?? nativeHeight;
  }

  /// The width of the frame of the texture.
  double get frameWidth {
    return frame?.width ?? nativeWidth;
  }

  /// The height of the texture.
  double? get height {
    return nativeHeight;
  }

  /// The height of the texture in pixels.
  double get nativeHeight {
    return root?.height.toDouble() ?? 0;
  }

  /// The width of the texture in pixels.
  double get nativeWidth {
    return root?.width.toDouble() ?? 0;
  }

  /// The width of the texture.
  double? get width {
    return nativeWidth;
  }

  /// Copies the properties of another [GTexture] to this one.
  void copyFrom(GTexture other) {
    root = other.root;
    color = other.color;
    actualWidth = other.actualWidth;
    actualHeight = other.actualHeight;
    sourceRect = other.sourceRect;
    pivotX = other.pivotX;
    pivotY = other.pivotY;
    scale = other.scale;
  }

  /// Disposes this texture's resources, including its image data if it has one.
  ///
  /// After calling this method, any attempts to render or access the texture
  /// will result in an error. Any other objects that depend on this texture
  /// should remove their references to it to allow its memory to be reclaimed.
  ///
  /// If this texture has already been disposed, calling this method has no
  /// effect.
  void dispose() {
    if (_disposed) {
      return;
    }
    root?.dispose();
    root = null;
    color = null;
//    width = height = nativeWidth = nativeHeight = 0;
    frame = null;
    scale9Grid = null;
    scale9GridDest = null;
    _disposed = true;
  }

  /// Gets the bounds of the texture.
  GRect? getBounds() {
    return sourceRect;
  }

  /// Renders the texture to the specified [canvas] using the optional [paint].
  ///
  /// If [scale] is not 1, the texture will be scaled down or up accordingly.
  /// The [paint] can be used to set various rendering options such as blending
  /// modes, filtering, and anti-aliasing. If no [paint] is provided, the
  /// default [Paint] instance will be used.
  ///
  void render(ui.Canvas canvas, [ui.Paint? paint]) {
    paint ??= $defaultPaint;
    if (scale != 1) {
      canvas.save();
      canvas.scale(1 / scale!);
      // canvas.drawImage(root, Offset.zero, paint);
      _drawImage(canvas, paint);
      canvas.restore();
    } else {
      _drawImage(canvas, paint);
    }
  }

  /// Draw the image on the provided canvas using the provided paint.
  ///
  /// If the texture has not been disposed and the root is not null, the image
  /// is drawn. If the texture has a scale 9 grid, the image is drawn using
  /// [canvas.drawImageNine]. Otherwise, [canvas.drawImage] is used.
  ///
  /// If [paint] is null, the default paint from [$defaultPaint] is used.
  void _drawImage(ui.Canvas canvas, ui.Paint paint) {
    if (_disposed || root == null) {
      return;
    }
    if (scale9Grid != null) {
      // print('src: $scale9Grid, dst: $scale9GridDest');
      canvas.drawImageNine(
        root!,
        scale9Grid!.toNative(),
        scale9GridDest!.toNative(),
        // sourceRect.toNative(),
        paint,
      );
    } else {
      canvas.drawImage(root!, ui.Offset.zero, paint);
    }
  }

  /// Creates an instance of [GTexture] with the specified dimensions and scale
  /// but empty.
  ///
  /// The [width] and [height] parameters represent the dimensions of the
  /// texture. The [scale] parameter is optional and can be used to specify the
  /// scale of the texture. If the [scale] parameter is not specified, the
  /// [contentScaleFactor] is used instead.
  ///
  static GTexture empty(double width, double height, [double scale = -1]) {
    if (scale <= 0) {
      scale = contentScaleFactor;
    }
    var oriWidth = width * scale;
    var oriHeight = height * scale;
    var actualW = oriWidth;
    var actualH = oriHeight;
    final t = GTexture();
    t.actualWidth = actualW;
    t.actualHeight = actualH;
    t.scale = scale;
    return t;
  }

  /// Creates a new [GTexture] with a solid color of the specified size and
  /// color.
  ///
  /// The [w] and [h] parameters specify the width and height of the texture,
  /// respectively. The [color] parameter specifies the color of the texture.
  /// The [scale] parameter specifies the scaling factor of the texture.
  ///
  /// Returns a new [GTexture] with the specified size and color.
  static GTexture fromColor(
    double w,
    double h,
    ui.Color color, [
    double scale = 1,
  ]) {
    var texture = GTexture.empty(w, h, scale);
    texture.color = color;
    return texture;
  }

  /// Creates a new [GTexture] instance from a given [ui.Image].
  ///
  /// The resulting texture size will be determined by the image dimensions
  /// divided by the given [scale]. If no scale is provided, it defaults to 1.
  ///
  /// The created texture will have the image set as its root, with its actual
  /// width and height set to the dimensions of the image.
  ///
  /// The [sourceRect] property will be set to a [GRect] with position (0, 0)
  /// and size equal to the dimensions of the image divided by the given
  /// [scale].
  ///
  /// Returns the created [GTexture] instance.
  static GTexture fromImage(
    ui.Image data, [
    double scale = 1,
  ]) {
    var texture =
        GTexture.empty(data.width / scale, data.height / scale, scale);
    texture.root = data;
    texture.actualWidth = data.width.toDouble();
    texture.actualHeight = data.height.toDouble();
    texture.sourceRect = GRect(0, 0, data.width / scale, data.height / scale);
    return texture;
  }

  /// TODO: all matrix calculation to map textures into vertices
//  GxPoint getTexCoords(VertexData vertex, int id, [GxPoint out]) {
//    out ??= GxPoint();
//  }
}
