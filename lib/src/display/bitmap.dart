import 'dart:ui' as ui;

import '../../graphx.dart';

/// A class that represents a bitmap image that can be displayed on the screen.
class GBitmap extends GDisplayObject {
  // A matrix used for calculating transformed bounds.
  static final _sHelperMatrix = GMatrix();

  // A point used for calculating transformed bounds.
  static final _sHelperPoint = GPoint();

  /// The texture displayed by this bitmap.
  GTexture? _texture;

  /// (Internal usage)
  /// The original pivot point for this bitmap.
  double $originalPivotX = 0, $originalPivotY = 0;

  /// Indicates whether the texture is scaled in a 9-slice grid.
  /// TODO: improve this process, make bounds work properly.
  late bool _hasScale9Grid;

  /// Buffers for storing the scale values of the texture when scaled in a
  /// 9-slice grid.
  double _buffScaleX = 0.0, _buffScaleY = 0.0;

  /// Cached bounds of this bitmap.
  final GRect _cachedBounds = GRect();

  /// The paint used to render this bitmap.
  final _paint = ui.Paint()..filterQuality = ui.FilterQuality.medium;

  /// Constructs a new GBitmap object with the specified [texture].
  GBitmap([GTexture? texture]) {
    this.texture = texture;
  }

  /// Sets the transparency of this object.
  @override
  set alpha(double value) {
    super.alpha = value;
    _paint.color = _paint.color.withOpacity($alpha);
  }

  /// Sets the color of this object.
  @override
  set colorize(ui.Color? value) {
    if ($colorize == value) {
      return;
    }
    super.colorize = value;
    _paint.colorFilter =
        $hasColorize ? PainterUtils.getColorize($colorize!) : null;
  }

  /// Sets the list of filters for this object.
  @override
  set filters(List<GBaseFilter>? value) {
    if ($filters == value) {
      return;
    }
    $filters = value;
    if ($filters == null) {
      _paint.imageFilter = null;
      _paint.maskFilter = null;
    }
  }

  /// Returns the native [ui.Paint] object.
  ui.Paint get nativePaint {
    return _paint;
  }

  /// Sets the horizontal coordinate of the object's origin point.
  @override
  set pivotX(double value) {
    $originalPivotX = value;
    super.pivotX = value;
  }

  /// Sets the vertical coordinate of the object's origin point.
  @override
  set pivotY(double value) {
    $originalPivotY = value;
    super.pivotY = value;
  }

  /// Returns the texture image of this [GBitmap] instance.
  GTexture? get texture {
    return _texture;
  }

  /// Sets the texture of this [GBitmap] instance.
  set texture(GTexture? value) {
    if (_texture == value) {
      return;
    }
    _texture = value;
    if (_texture != null) {
      pivotX = -_texture!.pivotX! + $originalPivotX;
      pivotY = -_texture!.pivotY! + $originalPivotY;
    }
    requiresRedraw();
  }

  /// (Internal usage)
  /// Applies the current paint to the given [canvas].
  ///
  /// If this object has filters, each filter is updated, and the filter paint
  /// is resolved before applying the texture paint.
  ///
  /// If the [texture] is not null, it is rendered with the current paint to
  /// the [canvas]. If [_hasScale9Grid] is true, the object's scale is set to
  /// [_buffScaleX] and [_buffScaleY] after rendering the texture.
  @override
  void $applyPaint(ui.Canvas canvas) {
    if (hasFilters) {
      for (var filter in filters!) {
        filter.update();
        filter.currentObject = this;
        filter.resolvePaint(_paint);
        filter.currentObject = null;
      }
    }
    texture?.render(canvas, _paint);
    if (_hasScale9Grid) {
      setScale(_buffScaleX, _buffScaleY);
    }
  }

  /// Returns the bounds of this bitmap in the local coordinate system of the
  /// specified [targetSpace].
  @override
  GRect getBounds(GDisplayObject? targetSpace, [GRect? out]) {
    out ??= GRect();
    final matrix = _sHelperMatrix;
    matrix.identity();
    getTransformationMatrix(targetSpace, matrix);
    if (texture != null) {
      var rect = texture!.getBounds()!;
      out = MatrixUtils.getTransformedBoundsRect(
        matrix,
        rect,
        out,
      );
    } else {
      matrix.transformCoords(0, 0, _sHelperPoint);
      out.setTo(_sHelperPoint.x, _sHelperPoint.y, 0, 0);
    }
    return out;
  }

  /// Paints the bitmap texture onto the canvas using its current transformation
  /// matrix and rendering properties. This method also handles rendering any
  /// filters that have been applied to the GBitmap.
  ///
  /// If the [texture] property is null, this method does nothing.
  ///
  /// If the [texture] property has a scale9Grid defined, then this method will
  /// call [_adjustScaleGrid] to adjust the pivot and scale of the bitmap to
  /// properly render the texture.
  ///
  /// Overrides the [paint] method of [GDisplayObject]. It is called by the
  /// parent display object during rendering if the object is visible.
  ///
  /// Params:
  /// - [canvas]: The canvas onto which the texture will be painted.
  ///
  /// Returns:
  /// - void
  @override
  void paint(ui.Canvas canvas) {
    if (texture == null) {
      return;
    }
    _hasScale9Grid = texture!.scale9Grid != null;
    if (_hasScale9Grid) {
      _adjustScaleGrid();
    }
    super.paint(canvas);
  }

  /// Returns a string representation of this object.
  @override
  String toString() {
    final textureInfo =
        texture != null ? '(${texture!.width}x${texture!.height})' : '';
    final nameInfo = name != null ? ' {name: $name}' : '';
    final scaleInfo =
        scaleX != 1 || scaleY != 1 ? ' [scale: ($scaleX,$scaleY)]' : '';
    return '$runtimeType$textureInfo$nameInfo$scaleInfo';
  }

  /// Adjusts the scale 9 grid to match the current [texture] scale and
  /// [_buffScaleX] and [_buffScaleY]. Also updates the [_cachedBounds] with the
  /// new size.
  ///
  /// Used to adjust the scale of the object when the [texture]'s scale9Grid is
  /// set. This method sets [_buffScaleX] and [_buffScaleY] as the current scale
  /// and then updates the pivot points and [_cachedBounds] to match the new
  /// size. It also sets the [texture]'s [scale9GridDest] to [_cachedBounds].
  /// Finally, it sets the object's scale to (1,1) to match the unscaled
  /// [_cachedBounds].
  void _adjustScaleGrid() {
    _buffScaleX = scaleX;
    _buffScaleY = scaleY;
    super.pivotX = $originalPivotX * _buffScaleX;
    super.pivotY = $originalPivotY * _buffScaleY;
    _cachedBounds.x = _cachedBounds.y = 0;
    _cachedBounds.width = texture!.width! * _buffScaleX;
    _cachedBounds.height = texture!.height! * _buffScaleY;
    texture!.scale9GridDest = _cachedBounds;
    setScale(1, 1);
  }
}
