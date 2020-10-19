import 'package:graphx/graphx/display/display_object.dart';
import 'package:graphx/graphx/render/graphics.dart';

class Shape extends DisplayObject {
  Graphics _graphics;

  Graphics get graphics => _graphics ??= Graphics();

  @override
  void $applyPaint() {
    _graphics?.alpha = worldAlpha;
    _graphics?.paint($canvas);
  }

  @override
  void dispose() {
    _graphics?.dispose();
    _graphics = null;
    super.dispose();
  }
}
