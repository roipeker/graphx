import 'dart:ui';

import '../../graphx/display/display_object.dart';
import '../../graphx/display/display_object_container.dart';
import '../../graphx/geom/gxmatrix.dart';
import '../../graphx/geom/gxpoint.dart';
import '../../graphx/geom/gxrect.dart';
import '../../graphx/render/graphics.dart';
import '../../graphx/utils/matrix_utils.dart';

class Shape extends IAnimatable {
  Graphics _graphics;
  static GxMatrix _sHelperMatrix = GxMatrix();

  @override
  String toString() {
    final msg = name != null ? ' {name: $name}' : '';
    return '$runtimeType (Shape)$msg';
  }

  Graphics get graphics => _graphics ??= Graphics();

  @override
  GxRect getBounds(IAnimatable targetSpace, [GxRect out]) {
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
          matrix, _graphics.getBounds(out));
    } else {
      final pos = DisplayObjectContainer.$sBoundsPoint;
      matrix.transformCoords(0, 0, pos);
      out.setTo(pos.x, pos.y, 0, 0);
    }
    return out;
//    print("Transform matrix:: $m");
//    getTransformationMatrix(targetSpace, _sBoundsMatrix);
//    _sBoundsMatrix.transformCoords(0, 0, _sBoundsPoint);
//    out.setTo(_sBoundsPoint.x, _sBoundsPoint.y, 0, 0);

//    m.transformCoords(0, 0, p);
//    out.setTo(p.x, p.y, 0, 0);
//    print(m);
//    print(p);
//    if(!visible||!touchable ||!hitTestMask(loca))
    return _graphics?.getBounds();
  }

  @override
  IAnimatable hitTest(GxPoint localPoint, [bool useShape = false]) {
    if (!visible || !touchable) return null;
    return (_graphics?.hitTest(localPoint, useShape) ?? false) ? this : null;
  }

//  override public function hitTest(localPoint:Point):DisplayObject
//  {
//  if (!visible || !touchable || !hitTestMask(localPoint)) return null;
//  else return MeshUtil.containsPoint(_vertexData, _indexData, localPoint) ? this : null;
//  }

  //        canvas.clipPath(path)
  //      canvas.clipPath(path)

  @override
  void $applyPaint() {
    if (isMask && _graphics != null) {
//      $canvas.save();
//      $canvas.transform(transformationMatrix.toNative().storage);

      Path paths = _graphics.getPaths();
      GxMatrix matrix;
      if (inStage && $maskee.inStage) {
        matrix = getTransformationMatrix($maskee);
      } else {
        matrix = transformationMatrix;
      }

      paths = paths.transform(matrix.toNative().storage);
//      paths = paths.transform(transformationMatrix.toNative().storage);

      $canvas.clipPath(paths);

//      _graphics?.isMask = this.isMask;
//      _graphics?.paint($canvas);
//      $canvas.restore();
    } else {
      _graphics?.isMask = this.isMask;
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
