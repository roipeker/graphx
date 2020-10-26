import 'package:graphx/graphx/graphx.dart';
import 'package:graphx/graphx/render/graphics.dart';
import 'package:graphx/graphx/textures/base_texture.dart';

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
}
