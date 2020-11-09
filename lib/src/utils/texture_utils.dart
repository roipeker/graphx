import '../../graphx.dart';

abstract class TextureUtils {
  static final Shape _helperShape = Shape();

  static Graphics get _g => _helperShape.graphics;
  static double resolution = 1.0;

  static Future<GTexture> createCircle({
    int color = 0xff00ff,
    double alpha = 1,
    double radius = 20,
    double x = 0,
    double y = 0,
    String id,
  }) async {
    _g.clear()..beginFill(color, alpha).drawCircle(x, y, radius);
    return await _drawShape(id);
  }

  static Future<GTexture> createRect({
    int color = 0xff00ff,
    double alpha = 1,
    double x = 0,
    double y = 0,
    double w = 20,
    double h = 20,
    String id,
  }) async {
    _g.clear()..beginFill(color, alpha).drawRect(x, y, w, h);
    return (await _drawShape(id));
  }

  static Future<GTexture> createRoundRect({
    int color = 0xff00ff,
    double alpha = 1,
    double x = 0,
    double y = 0,
    double w = 20,
    double h = 20,
    double r = 8,
    String id,
  }) async {
    _g.clear()..beginFill(color, alpha).drawRoundRect(x, y, w, h, r);
    return (await _drawShape(id));
  }

  static Future<GTexture> createTriangle({
    int color = 0xff00ff,
    double alpha = 1,
    double w = 20,
    double h = 20,
    double rotation = 0,
    String id,
  }) async {
    _g
        .clear()
        .beginFill(color, alpha)
        .drawPolygonFaces(0, 0, w / 2, 3, rotation)
        .endFill();
    var heightScale = h / w;
    _helperShape.scaleY = heightScale;
    var tx = await _drawShape(id);
    _helperShape.scaleY = 1;
    return tx;
  }

  static Future<GTexture> _drawShape([String id]) async {
    final tx =
        await _helperShape.createImageTexture(true, TextureUtils.resolution);
    if (id != null) {
      AssetLoader.textures[id] = tx;
    }
    return tx;
  }

  static List<GxTexture> getRectAtlasFromGxTexture(
    GxTexture base,
    int w, {
    int h,
    int padding = 0,
    double scale = 1,
  }) {
    h ??= w;

    /// create SubTextures from the main Texture.
    var cols = base.sourceRect.width / w;
    var rows = base.sourceRect.height / h;
    var total = cols * rows;
    var output = <GxTexture>[];
    final _w = w.toDouble();
    final _h = h.toDouble();
    for (var i = 0; i < total; ++i) {
      final px = (i % cols) * _w;
      final py = (i ~/ cols) * _h;
      var subRect = GxRect(px, py, _w, _h);
      var texture = GxTexture(base.source, subRect, true, scale);
      texture.base = base;
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
