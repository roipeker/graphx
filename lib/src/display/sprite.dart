import 'dart:ui' as ui;

import '../../graphx.dart';

/// The [GSprite] class represents a display object that can be used to draw
/// vector graphics (using the internal [Graphics] ckass) and can also contain
/// child display objects.
class GSprite extends GDisplayObjectContainer {
  @override
  String toString() {
    final msg = name != null ? '(name:"$name")' : '';
    return '$runtimeType#$hashCode$msg';
  }

  static final _sHelperMatrix = GMatrix();

  Graphics? _graphics;

  Graphics get graphics => _graphics ??= Graphics();

  /// Returns a [GRect] object representing the bounds of this [GSprite] in the
  /// coordinate space of the [targetSpace] object. If the [out] parameter is not
  /// null, the result will be stored in that object and returned. Otherwise, a
  /// new [GRect] object will be created and returned. If this [GSprite] has
  /// graphics, the bounds will be expanded to include the bounds of the graphics.
  ///
  /// The [targetSpace] parameter is the object that defines the coordinate
  /// system to use for the resulting bounds. If it is null, the bounds will be
  /// calculated in the local coordinate space of this [GSprite].
  ///
  /// The [out] parameter is an optional object that will be used to store the
  /// result. If it is not null, the result will be stored in that object and
  /// returned. Otherwise, a new [GRect] object will be created and returned.
  ///
  /// Returns a [GRect] object representing the bounds of this [GSprite] in the
  /// coordinate space of the [targetSpace] object.
  @override
  GRect? getBounds(GDisplayObject? targetSpace, [GRect? out]) {
    out = super.getBounds(targetSpace, out);
    if (_graphics != null) {
      _sHelperMatrix.identity();
      getTransformationMatrix(targetSpace, _sHelperMatrix);

      /// single bounds, all paths as 1 rect.
      final graphicsBounds = _graphics!.getBounds();
      MatrixUtils.getTransformedBoundsRect(
        _sHelperMatrix,
        graphicsBounds,
        graphicsBounds,
      );
      out!.expandToInclude(graphicsBounds);
    }
    return out;
  }

  /// Determines if the point specified by [localPoint] is contained within this
  /// [GSprite]. If [useShape] is true, the shape of the [GSprite] will be used
  /// to test for containment. Otherwise, the bounds of the [GSprite] will be
  /// used.
  ///
  /// The [localPoint] parameter is a [GPoint] object representing the point to
  /// test for containment, in the local coordinate space of this [GSprite].
  ///
  /// The [useShape] parameter is an optional boolean value that determines
  /// whether to use the shape of the [GSprite] or the bounds of the [GSprite] to
  /// test for containment. If it is not specified, it will default to false.
  ///
  /// Returns the [GDisplayObject] that contains the point, or null if the point
  /// is not contained within this [GSprite].
  @override
  GDisplayObject? hitTest(GPoint localPoint, [bool useShape = false]) {
    if (!visible || !mouseEnabled) return null;
    var target = super.hitTest(localPoint);
    target ??=
        (_graphics?.hitTest(localPoint, useShape) ?? false) ? this : null;
    return target;
  }

  /// Applies the paint to the given [canvas] for this [GSprite]. The graphics
  /// will be used to paint the [canvas], and if this [GSprite] has child display
  /// objects, their paint will also be applied.
  ///
  /// The [canvas] parameter is the [ui.Canvas] object to apply the paint to.
  @override
  void $applyPaint(ui.Canvas canvas) {
    if (!$hasVisibleArea) return;
    _graphics?.alpha = worldAlpha;
    _graphics?.paint(canvas);
    if (hasChildren) {
      super.$applyPaint(canvas);
    }
  }

  /// Disposes of this [GSprite] and its graphics resources.
  @override
  @mustCallSuper
  void dispose() {
    /// TODO: dispose children?
    _graphics?.dispose();
    _graphics = null;
    super.dispose();
  }
}
