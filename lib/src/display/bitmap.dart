import 'dart:ui';

import '../../graphx.dart';

class Bitmap extends DisplayObject {
  static final _sHelperMatrix = GxMatrix();
  static final _sHelperPoint = GxPoint();

  @override
  String toString() {
    final msg = name != null ? ' {name: $name}' : '';
    return '$runtimeType (Bitmap2)$msg';
  }

  GTexture _texture;

  GTexture get texture => _texture;

  double $originalPivotX = 0;
  double $originalPivotY = 0;

  @override
  set pivotX(double value) {
    $originalPivotX = value;
    super.pivotX = value;
  }

  @override
  set pivotY(double value) {
    $originalPivotY = value;
    super.pivotY = value;
  }

  set texture(GTexture value) {
    if (_texture == value) return;
    _texture = value;
    if (_texture != null) {
      pivotX = -_texture.pivotX + $originalPivotX;
      pivotY = -_texture.pivotY + $originalPivotY;
    }
    requiresRedraw();
  }

  Bitmap([GTexture texture]) {
    this.texture = texture;
  }

  @override
  GxRect getBounds(DisplayObject targetSpace, [GxRect out]) {
    out ??= GxRect();
    final matrix = _sHelperMatrix;
    matrix.identity();
    getTransformationMatrix(targetSpace, matrix);
    if (texture != null) {
      var rect = texture.getBounds();
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

  final _paint = Paint()..filterQuality = FilterQuality.high;

  Paint get nativePaint => _paint;

  @override
  set alpha(double value) {
    super.alpha = value;
    _paint.color = _paint.color.withOpacity($alpha);
  }

  @override
  set colorize(Color value) {
    if ($colorize == value) return;
    super.colorize = value;
    _paint.colorFilter =
        $hasColorize ? PainterUtils.getColorize($colorize) : null;
  }

  @override
  set filters(List<BaseFilter> value) {
    if ($filters == value) return;
    $filters = value;
    if ($filters == null) {
      _paint.imageFilter = null;
      _paint.maskFilter = null;
    }
  }

  @override
  void paint(Canvas canvas) {
    if (texture == null) return;
    _hasScale9Grid = texture.scale9Grid != null;
    if (_hasScale9Grid) {
      _adjustScaleGrid();
    }
    super.paint(canvas);
  }

  @override
  void $applyPaint(Canvas canvas) {
    if (hasFilters) {
      filters.forEach((filter) {
        filter.update();
        filter.resolvePaint(_paint);
      });
    }

    texture?.render(canvas, _paint);
    if (_hasScale9Grid) {
      setScale(_buffScaleX, _buffScaleY);
    }
  }

  /// TODO: improve this process, make bounds work properly.
  bool _hasScale9Grid;
  double _buffScaleX, _buffScaleY;
  final GxRect _cachedBounds = GxRect();

  void _adjustScaleGrid() {
    _buffScaleX = scaleX;
    _buffScaleY = scaleY;
    super.pivotX = $originalPivotX * _buffScaleX;
    super.pivotY = $originalPivotY * _buffScaleY;
    _cachedBounds.x = _cachedBounds.y = 0;
    _cachedBounds.width = texture.width * _buffScaleX;
    _cachedBounds.height = texture.height * _buffScaleY;
    texture.scale9GridDest = _cachedBounds;
    setScale(1, 1);
  }
}
