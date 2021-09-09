import 'dart:ui' as ui;
import '../../graphx.dart';

mixin GTextureUtils {
  static final GShape _helperShape = GShape();

  static Graphics get _g => _helperShape.graphics;
  static double resolution = 1.0;

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

  static Future<GTexture> createCircle({
    ui.Color color = kColorMagenta,
    double radius = 20,
    double x = 0,
    double y = 0,
    String? id,
  }) async {
    _g.clear()..beginFill(color).drawCircle(x, y, radius);
    return await _drawShape(id);
  }

  static Future<GTexture> createRect({
    ui.Color color = kColorMagenta,
    double x = 0,
    double y = 0,
    double w = 20,
    double h = 20,
    String? id,
  }) async {
    _g.clear()..beginFill(color).drawRect(x, y, w, h);
    return (await _drawShape(id));
  }

  static Future<GTexture> createRoundRect({
    ui.Color color = kColorMagenta,
    double x = 0,
    double y = 0,
    double w = 20,
    double h = 20,
    double r = 8,
    String? id,
  }) async {
    _g.clear()..beginFill(color).drawRoundRect(x, y, w, h, r);
    return (await _drawShape(id));
  }

  static Future<GTexture> createTriangle({
    ui.Color color = kColorMagenta,
    double w = 20,
    double h = 20,
    double rotation = 0,
    String? id,
  }) async {
    _g
        .clear()
        .beginFill(color)
        .drawPolygonFaces(0, 0, w / 2, 3, rotation)
        .endFill();
    var heightScale = h / w;
    _helperShape.scaleY = heightScale;
    var tx = await _drawShape(id);
    _helperShape.scaleY = 1;
    return tx;
  }

  static Future<GTexture> _drawShape([String? id]) async {
    final tx = await _helperShape.createImageTexture(
      true,
      GTextureUtils.resolution,
    );
    if (id != null) {
      ResourceLoader.textureCache[id] = tx;
    }
    return tx;
  }

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
    final _w = w.toDouble();
    final _h = h.toDouble();
    for (var i = 0; i < total; ++i) {
      final px = (i % cols) * _w;
      final py = (i ~/ cols) * _h;
      var subRect = GRect(px, py, _w, _h);
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

  static bool isValidTextureSize(int size) {
    return getNextValidTextureSize(size) == size;
  }

  static int getNextValidTextureSize(int size) {
    var _size = 1;
    while (size > _size) {
      _size *= 2;
    }
    return _size;
  }

  static int getPreviousValidTextureSize(int size) {
    return getNextValidTextureSize(size) >> 1;
  }

  static int getNearestValidTextureSize(int size) {
    final prev = getPreviousValidTextureSize(size);
    final next = getNextValidTextureSize(size);
    return size - prev < next - size ? prev : next;
  }
}
