import 'dart:ui' as ui;
import '../../graphx.dart';

class GShape extends GDisplayObject {
  Graphics? _graphics;
  static final _sHelperMatrix = GMatrix();

  @override
  String toString() {
    final msg = name != null ? ' {name: $name}' : '';
    return '$runtimeType (Shape)$msg';
  }

  Graphics get graphics => _graphics ??= Graphics();

  @override
  GRect? getBounds(GDisplayObject? targetSpace, [GRect? out]) {
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
          matrix, _graphics!.getBounds(out), out);
    } else {
      final pos = GDisplayObjectContainer.$sBoundsPoint;
      matrix.transformCoords(0, 0, pos);
      out!.setTo(pos.x, pos.y, 0, 0);
    }
    return out;
  }

  @override
  GDisplayObject? hitTest(GPoint localPoint, [bool useShape = false]) {
    if (!$hasTouchableArea || !mouseEnabled) {
      return null;
    }
    if (($mask != null || maskRect != null) && !hitTestMask(localPoint)) {
      return null;
    }
    return (_graphics?.hitTest(localPoint, useShape) ?? false) ? this : null;
  }

  static ui.Path? _inverseHugePath;
  static void _initInversePath() {
    if (_inverseHugePath != null) {
      return;
    }
    _inverseHugePath = ui.Path();
    const w = 100000.0;
    var r = Pool.getRect(-w / 2, -w / 2, w, w);
    _inverseHugePath!.addRect(r.toNative());
    _inverseHugePath!.close();
  }

  @override
  void $applyPaint(ui.Canvas canvas) {
    if (isMask && _graphics != null) {
      GMatrix matrix;
      var paths = _graphics!.getPaths();
      if (inStage && $maskee!.inStage) {
        matrix = getTransformationMatrix($maskee);
      } else {
        matrix = transformationMatrix;
      }
      var clipPath = paths.transform(matrix.toNative().storage);
      final inverted = maskInverted || $maskee!.maskInverted;
      if (inverted) {
        _initInversePath();
//        var invPath = Graphics.stageRectPath;
//        var rect = $maskee.bounds;
//        invPath = invPath.shift(Offset(rect.x, rect.y));
        if (SystemUtils.usingSkia) {
          clipPath = ui.Path.combine(
              ui.PathOperation.difference, _inverseHugePath!, clipPath);
          canvas.clipPath(clipPath);
        } else {
          trace('Shape.maskInverted is unsupported in the current platform');
        }
      } else {
        canvas.clipPath(clipPath);
      }
    } else {
      _graphics?.isMask = isMask;
      _graphics?.alpha = worldAlpha;
      _graphics?.paint(canvas);
    }
  }

  @override
  void dispose() {
    _graphics?.dispose();
    _graphics = null;
    super.dispose();
  }
}
