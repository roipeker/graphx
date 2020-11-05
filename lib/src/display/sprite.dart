import '../../graphx.dart';
import 'display_object.dart';

class Sprite extends DisplayObjectContainer {
  @override
  String toString() {
    final msg = name != null ? ' {name: $name}' : '';
    return '$runtimeType (Sprite)$msg';
  }

  static final _sHelperMatrix = GxMatrix();
  static final _sHelperPoint = GxPoint();

  Graphics _graphics;
  Graphics get graphics => _graphics ??= Graphics();

  @override
  GxRect getBounds(DisplayObject targetSpace, [GxRect out]) {
    out = super.getBounds(targetSpace, out);
//    final matrix = _sHelperMatrix;
//    matrix.identity();
//    getTransformationMatrix(targetSpace, matrix);
//    if (_graphics != null) {
//      /// add graphics later.
////      out ??= GxRect();
//      var _allBounds = _graphics.getAllBounds();
//      _allBounds.forEach((localBounds) {
////        out ??= GxRect();
//        /// modify the same instance.
//        var newRect = MatrixUtils.getTransformedBoundsRect(
//          matrix,
//          localBounds,
//          localBounds,
//        );
//        out.expandToInclude(newRect);
//      });
//    } else {
//      MatrixUtils.getTransformedBoundsRect(matrix, out, out);
//    print('inner get bounds: $out $this');

//    }
    return out;
  }

  @override
  DisplayObject hitTest(GxPoint localPoint, [bool useShape = false]) {
    if (!visible || !mouseEnabled) return null;
    DisplayObject target = super.hitTest(localPoint);
    if (target == null) {
      target =
          (_graphics?.hitTest(localPoint, useShape) ?? false) ? this : null;
    }
    return target;
  }

  @override
  void $applyPaint() {
    if (!$hasVisibleArea) return;
    _graphics?.alpha = worldAlpha;
    _graphics?.paint($canvas);
    if (hasChildren) {
      super.$applyPaint();
    }
  }

  @override
  void dispose() {
    _graphics?.dispose();
    _graphics = null;
    super.dispose();
  }
}
