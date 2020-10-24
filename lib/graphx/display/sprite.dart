import 'package:graphx/graphx/display/display_object_container.dart';
import 'package:graphx/graphx/geom/gxmatrix.dart';
import 'package:graphx/graphx/geom/gxpoint.dart';
import 'package:graphx/graphx/geom/gxrect.dart';
import 'package:graphx/graphx/render/graphics.dart';
import 'package:graphx/graphx/utils/matrix_utils.dart';

import 'display_object.dart';

class Sprite extends DisplayObjectContainer {
  @override
  String toString() {
    final msg = name != null ? ' {name: $name}' : '';
    return '$runtimeType (Sprite)$msg';
  }

  static GxMatrix _sHelperMatrix = GxMatrix();
  static GxPoint _sHelperPoint = GxPoint();

  Graphics _graphics;

  Graphics get graphics => _graphics ??= Graphics();

  @override
  GxRect getBounds(DisplayObject targetSpace, [GxRect out]) {
    out = super.getBounds(targetSpace, out);
    if (_graphics != null) {
      /// add graphics later.
      final matrix = _sHelperMatrix;
      matrix.identity();
      getTransformationMatrix(targetSpace, matrix);
//      out ??= GxRect();
      var _allBounds = _graphics.getAllBounds();
//      out?.setEmpty();
      _allBounds.forEach((localBounds) {
//        out ??= GxRect();
        /// modify the same instance.
        out.expandToInclude(MatrixUtils.getTransformedBoundsRect(
          matrix,
          localBounds,
          localBounds,
        ));
      });
    }
    return out;
  }

  @override
  DisplayObject hitTest(GxPoint localPoint, [bool useShape = false]) {
    if (!visible || !touchable) return null;
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
