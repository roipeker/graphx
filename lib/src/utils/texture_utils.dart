import '../../graphx.dart';

abstract class TextureUtils {
  static final Shape _helperShape = Shape();

  static Graphics get _g => _helperShape.graphics;
  static double resolution = 1.0;

  static Future<GxTexture> createCircle({
    int color = 0xff00ff,
    double alpha = 1,
    double radius = 20,
    double x = 0,
    double y = 0,
  }) async {
    _g.clear()..beginFill(color, alpha).drawCircle(x, y, radius);
    return (await _drawShape());
  }

  static Future<GxTexture> createRect({
    int color = 0xff00ff,
    double alpha = 1,
    double x = 0,
    double y = 0,
    double w = 20,
    double h = 20,
  }) async {
    _g.clear()..beginFill(color, alpha).drawRect(x, y, w, h);
    return (await _drawShape());
  }

  static Future<GxTexture> createTriangle({
    int color = 0xff00ff,
    double alpha = 1,
    double w = 20,
    double h = 20,
    double rotation = 0,
  }) async {
    _g
        .clear()
        .beginFill(color, alpha)
        .drawPolygonFaces(0, 0, w / 2, 3, rotation)
        .endFill();
    var heightScale = h / w;
    _helperShape.scaleY = heightScale;
    var tx = await _drawShape();
    _helperShape.scaleY = 1;
    return tx;
  }

  static Future<GxTexture> _drawShape() {
    return _helperShape.createImageTexture(true, TextureUtils.resolution);
  }

  static List<GxTexture> getRectAtlasFromTexture(
    GxTexture base,
    int w, {
    int h,
    int padding = 0,
    double scale = 1,
  }) {
    h ??= w;

    /// create subtextures from the main texture.
    var cols = base.sourceRect.width / w;
    var rows = base.sourceRect.height / h;
    var total = cols * rows;
    var output = <GxTexture>[];
    final _w = w.toDouble();
    final _h = h.toDouble();
    for (var i = 0; i < total; ++i) {
      final px = (i % cols) * _w;
      final py = (i ~/ cols) * _h;
      var subrect = GxRect(px, py, _w, _h);
      var texture = GxTexture(base.source, subrect, true, scale);
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
