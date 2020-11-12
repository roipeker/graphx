import '../../graphx.dart';

class GTexture {
  GxRect frame;
  // set from the outside.
  GxRect scale9Grid;
  GxRect scale9GridDest;

  double get width => nativeWidth;

  double get height => nativeHeight;

  double get nativeWidth => root?.width?.toDouble() ?? 0;

  double get nativeHeight => root?.height?.toDouble() ?? 0;

  /// when the texture is plain color.
  Color color;

  /// used width.
  double get frameWidth => frame?.width ?? nativeWidth;

  double get frameHeight => frame?.height ?? nativeHeight;

  /// set this by hand.
  double actualWidth, actualHeight;

  double pivotX = 0, pivotY = 0;
  GxRect sourceRect;

  double scale = 1;
  Image root;

  GxRect getBounds() {
    return sourceRect;
  }

  static GTexture fromColor(double w, double h, Color color,
      [double scale = 1]) {
    var texture = GTexture.empty(w, h, scale);
    texture.color = color;
    return texture;
  }

  static GTexture fromImage(
    Image data, [
    double scale = 1,
  ]) {
    var texture =
        GTexture.empty(data.width / scale, data.height / scale, scale);
    texture.root = data;
    texture.actualWidth = data.width.toDouble();
    texture.actualHeight = data.height.toDouble();
    texture.sourceRect = GxRect(0, 0, data.width / scale, data.height / scale);
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

  static Paint sDefaultPaint = Paint();

  void render(Canvas canvas, [Paint paint]) {
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

  void _drawImage(Canvas canvas, Paint paint) {
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
      canvas.drawImage(root, Offset.zero, paint);
    }
  }

  void dispose() {
    root?.dispose();
    root = null;
    color = null;
//    width = height = nativeWidth = nativeHeight = 0;
    frame = null;
  }

  /// TODO: all matrix calculation to map textures into vertices
//  GxPoint getTexCoords(VertexData vertex, int id, [GxPoint out]) {
//    out ??= GxPoint();
//  }
}
