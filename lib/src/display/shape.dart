import 'dart:ui';

import '../../graphx.dart';

class Shape extends DisplayObject {
  Graphics _graphics;
  static final _sHelperMatrix = GxMatrix();

  @override
  String toString() {
    final msg = name != null ? ' {name: $name}' : '';
    return '$runtimeType (Shape)$msg';
  }

  Graphics get graphics => _graphics ??= Graphics();

  @override
  GxRect getBounds(DisplayObject targetSpace, [GxRect out]) {
    final matrix = _sHelperMatrix;
    matrix.identity();
    getTransformationMatrix(targetSpace, matrix);
    if (_graphics != null) {
      /// todo: fix the rect size.
//      var _allBounds = _graphics.getAllBounds();
//      out?.setEmpty();
//      _allBounds.forEach((localBounds) {
//        out ??= GxRect();
//        /// modify the same instance.
//        out.expandToInclude(MatrixUtils.getTransformedBoundsRect(
//          matrix,
//          localBounds,
//          localBounds,
//        ));
//      });
      /// single bounds, all paths as 1 rect.
      return MatrixUtils.getTransformedBoundsRect(
          matrix, _graphics.getBounds(out), out);
    } else {
      final pos = DisplayObjectContainer.$sBoundsPoint;
      matrix.transformCoords(0, 0, pos);
      out.setTo(pos.x, pos.y, 0, 0);
    }
    return out;
  }

  @override
  DisplayObject hitTest(GxPoint localPoint, [bool useShape = false]) {
    if (!$hasVisibleArea || !mouseEnabled) {
      return null;
    }
    return (_graphics?.hitTest(localPoint, useShape) ?? false) ? this : null;
  }

  @override
  void $applyPaint() {
    if (isMask && _graphics != null) {
      GxMatrix matrix;
      var paths = _graphics.getPaths();
      if (inStage && $maskee.inStage) {
        matrix = getTransformationMatrix($maskee);
      } else {
        matrix = transformationMatrix;
      }
      paths = paths.transform(matrix.toNative().storage);
      $canvas.clipPath(paths);
    } else {
      _graphics?.isMask = isMask;
      _graphics?.alpha = worldAlpha;
      _graphics?.paint($canvas);
    }
  }

  @override
  void dispose() {
    _graphics?.dispose();
    _graphics = null;
    super.dispose();
  }
}
