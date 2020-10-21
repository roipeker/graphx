import 'package:graphx/graphx/display/display_object_container.dart';
import 'package:graphx/graphx/geom/gxpoint.dart';
import 'package:graphx/graphx/geom/gxrect.dart';
import 'package:graphx/graphx/render/graphics.dart';

import 'display_object.dart';

class Sprite extends DisplayObjectContainer {
  @override
  String toString() {
    final msg = name != null ? ' {name: $name}' : '';
    return '$runtimeType (Sprite)$msg';
  }

  Graphics _graphics;

  Graphics get graphics => _graphics ??= Graphics();

  @override
  GxRect getBounds(DisplayObject targetSpace, [GxRect out]) {
//    if (targetSpace == this) {}
    final matrix = DisplayObjectContainer.$sBoundsMatrix;
    matrix.identity();
    getTransformationMatrix(targetSpace, matrix);
    if (_graphics != null) {
      out = _graphics.getBounds(out);
      double minX = 10000000.0;
      double maxX = -10000000.0;
      double minY = 10000000.0;
      double maxY = -10000000.0;
      double tx1 = matrix.a * out.x + matrix.c * out.y + matrix.tx;
      double ty1 = matrix.d * out.y + matrix.b * out.x + matrix.ty;
      double tx2 = matrix.a * out.x + matrix.c * out.bottom + matrix.tx;
      double ty2 = matrix.d * out.bottom + matrix.b * out.x + matrix.ty;
      double tx3 = matrix.a * out.right + matrix.c * out.y + matrix.tx;
      double ty3 = matrix.d * out.y + matrix.b * out.right + matrix.ty;
      double tx4 = matrix.a * out.right + matrix.c * out.bottom + matrix.tx;
      double ty4 = matrix.d * out.bottom + matrix.b * out.right + matrix.ty;
      if (minX > tx1) minX = tx1;
      if (minX > tx2) minX = tx2;
      if (minX > tx3) minX = tx3;
      if (minX > tx4) minX = tx4;
      if (minY > ty1) minY = ty1;
      if (minY > ty2) minY = ty2;
      if (minY > ty3) minY = ty3;
      if (minY > ty4) minY = ty4;
      if (maxX < tx1) maxX = tx1;
      if (maxX < tx2) maxX = tx2;
      if (maxX < tx3) maxX = tx3;
      if (maxX < tx4) maxX = tx4;
      if (maxY < ty1) maxY = ty1;
      if (maxY < ty2) maxY = ty2;
      if (maxY < ty3) maxY = ty3;
      if (maxY < ty4) maxY = ty4;
      out.setTo(minX, minY, maxX - minX, maxY - minY);
    } else {
      final pos = DisplayObjectContainer.$sBoundsPoint;
      matrix.transformCoords(0, 0, pos);
      out.setTo(pos.x, pos.y, 0, 0);
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
