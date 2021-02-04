import 'dart:ui' as ui;

import '../../graphx.dart';

class GTexture {
  GRect frame;

  // set from the outside.
  GRect scale9Grid;
  GRect scale9GridDest;

  double get width => nativeWidth;

  double get height => nativeHeight;

  double get nativeWidth => root?.width?.toDouble() ?? 0;

  double get nativeHeight => root?.height?.toDouble() ?? 0;

  /// when the texture is plain color.
  ui.Color color;

  /// used width.
  double get frameWidth => frame?.width ?? nativeWidth;

  double get frameHeight => frame?.height ?? nativeHeight;

  /// set this by hand.
  double actualWidth, actualHeight;

  double pivotX = 0, pivotY = 0;
  GRect sourceRect;

  double scale = 1;
  ui.Image root;

  /// copy Image data, and properties from other GTexture instance.
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

  GRect getBounds() {
    return sourceRect;
  }

  static GTexture fromColor(double w, double h, ui.Color color,
      [double scale = 1]) {
    var texture = GTexture.empty(w, h, scale);
    texture.color = color;
    return texture;
  }

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

  static double contentScaleFactor = 1;

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

  static ui.Paint sDefaultPaint = ui.Paint();

  void render(ui.Canvas canvas, [ui.Paint paint]) {
    paint ??= sDefaultPaint;
    if (scale != 1) {
      canvas.save();
      canvas.scale(1 / scale);
      // canvas.drawImage(root, Offset.zero, paint);
      _drawImage(canvas, paint);
      canvas.restore();
    } else {
      _drawImage(canvas, paint);
    }
  }

  void _drawImage(ui.Canvas canvas, ui.Paint paint) {
    if (scale9Grid != null) {
      // print('src: $scale9Grid, dst: $scale9GridDest');
      canvas.drawImageNine(
        root,
        scale9Grid.toNative(),
        scale9GridDest.toNative(),
        // sourceRect.toNative(),
        paint,
      );
    } else {
      canvas.drawImage(root, ui.Offset.zero, paint);
    }
  }

  var _disposed = false;

  bool get disposed => _disposed;

  void dispose() {
    if (_disposed) return;
    root?.dispose();
    root = null;
    color = null;
//    width = height = nativeWidth = nativeHeight = 0;
    frame = null;
    scale9Grid = null;
    scale9GridDest = null;
    _disposed = true;
  }

  /// TODO: all matrix calculation to map textures into vertices
//  GxPoint getTexCoords(VertexData vertex, int id, [GxPoint out]) {
//    out ??= GxPoint();
//  }
}
