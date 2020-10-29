import '../../graphx/core/graphx.dart';
import '../../graphx/render/graphics.dart';
import '../../graphx/textures/base_texture.dart';

abstract class TextureUtils {
  static Shape _helperShape = Shape();

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
    double heightScale = h / w;
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
    double _w = w.toDouble();
    double _h = h.toDouble();
    for (var i = 0; i < total; ++i) {
      double px = (i % cols) * _w;
      double py = (i ~/ cols) * _h;
      var subrect = GxRect(px, py, _w, _h);
      var texture = GxTexture(base.source, subrect, true, scale);
      texture.base = base;
      output.add(texture);
    }
    return output;
  }
}
