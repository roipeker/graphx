import 'dart:ui' as ui;

import '../../graphx.dart';

/// The [GShape] class represents a display object that can be used to draw
/// vector graphics using the [Graphics] class. It extends the [GDisplayObject]
/// so is renders on screen.
class GShape extends GDisplayObject {
  /// A helper matrix used for various calculations.
  static final _sHelperMatrix = GMatrix();

  static ui.Path? _inverseHugePath;

  // The [Graphics] object associated with this [GShape].
  Graphics? _graphics;

  /// Returns the [Graphics] object associated with this [GShape], creating it
  /// if it doesn't already exist. The [Graphics] object is used to draw vector
  /// graphics.
  Graphics get graphics {
    return _graphics ??= Graphics();
  }

  /// (Internal usage) Applies the paint to the given [canvas] for this
  /// [GShape]. If this [GShape] is being used as a mask, the graphics will be
  /// used to clip the [canvas].
  ///
  /// The [canvas] parameter is the [ui.Canvas] object to apply the paint to.
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

  /// Disposes of this [GShape] and its graphics resources.
  @override
  void dispose() {
    _graphics?.dispose();
    _graphics = null;
    super.dispose();
  }

  /// Returns the bounds of this [GShape] in the coordinate system of the
  /// [targetSpace] object. If the [out] parameter is not null, the result will
  /// be stored in that object and returned. Otherwise, a new [GRect] object
  /// will be created and returned. If this [GShape] has no graphics, the bounds
  /// will be based on its position and size.
  ///
  /// The [matrix] parameter is an optional matrix that is used to transform the
  /// bounds from the local coordinate space of this [GShape] to the coordinate
  /// space of the [targetSpace] object. If the [matrix] parameter is not
  /// specified, the identity matrix will be used.
  ///
  /// The [out] parameter is an optional object that will be used to store the
  /// result. If it is not null, the result will be stored in that object and
  /// returned. Otherwise, a new [GRect] object will be created and returned.
  ///
  /// Returns a [GRect] object representing the bounds of this [GShape] in the
  /// coordinate space of the [targetSpace] object.
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
        matrix,
        _graphics!.getBounds(out),
        out,
      );
    } else {
      final pos = GDisplayObjectContainer.$sBoundsPoint;
      matrix.transformCoords(0, 0, pos);
      out!.setTo(pos.x, pos.y, 0, 0);
    }
    return out;
  }

  /// Determines if the point specified by [localPoint] is contained within this
  /// [GShape]. If [useShape] is true, the shape of the [GShape] will be used to
  /// test for containment. Otherwise, the bounds of the [GShape] will be used.
  ///
  /// The [localPoint] parameter is a [GPoint] object representing the point to
  /// test for containment, in the local coordinate space of this [GShape].
  ///
  /// The [useShape] parameter is an optional boolean value that determines
  /// whether to use the shape of the [GShape] or the bounds of the [GShape] to
  /// test for containment. If it is not specified, it will default to false.
  ///
  /// Returns the [GDisplayObject] that contains the point, or null if the point
  /// is not contained within this [GShape].
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

  /// Returns a string representation of this object.
  @override
  String toString() {
    final msg = name != null ? ' {name: $name}' : '';
    return '$runtimeType (Shape)$msg';
  }

  /// Initializes an inverse "huge" path used for masking when the mask is
  /// inverted. This method is called internally when needed to initialize the
  /// path.
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
}
