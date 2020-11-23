import '../../graphx.dart';
import 'display_object.dart';

class Sprite extends DisplayObjectContainer {
  @override
  String toString() {
    final msg = name != null ? ' {name: $name}' : '';
    return '$runtimeType (Sprite)$msg';
  }

  
  static final _sHelperMatrix = GxMatrix();

  Graphics _graphics;

  Graphics get graphics => _graphics ??= Graphics();

  @override
  GxRect getBounds(DisplayObject targetSpace, [GxRect out]) {
    out = super.getBounds(targetSpace, out);
    if (_graphics != null) {
      _sHelperMatrix.identity();
      getTransformationMatrix(targetSpace, _sHelperMatrix);

      /// single bounds, all paths as 1 rect.
      final graphicsBounds = _graphics.getBounds();
      MatrixUtils.getTransformedBoundsRect(
        _sHelperMatrix,
        graphicsBounds,
        graphicsBounds,
      );
      out.expandToInclude(graphicsBounds);
    }
    return out;
  }

  @override
  DisplayObject hitTest(GxPoint localPoint, [bool useShape = false]) {
    if (!visible || !mouseEnabled) return null;
    var target = super.hitTest(localPoint);
    target ??=
        (_graphics?.hitTest(localPoint, useShape) ?? false) ? this : null;
    return target;
  }

  @override
  void $applyPaint(Canvas canvas) {
    if (!$hasVisibleArea) return;
    _graphics?.alpha = worldAlpha;
    _graphics?.paint(canvas);
    if (hasChildren) {
      super.$applyPaint(canvas);
    }
  }

  @override
  void dispose() {
    _graphics?.dispose();
    _graphics = null;
    super.dispose();
  }
}
