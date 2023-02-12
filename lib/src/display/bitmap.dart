import 'dart:ui' as ui;
import '../../graphx.dart';

class GBitmap extends GDisplayObject {
  static final _sHelperMatrix = GMatrix();
  static final _sHelperPoint = GPoint();

  @override
  String toString() {
    final msg = name != null ? ' {name: $name}' : '';
    return '$runtimeType (Bitmap2)$msg';
  }

  GTexture? _texture;
  GTexture? get texture => _texture;
  double $originalPivotX = 0, $originalPivotY = 0;

  /// TODO: improve this process, make bounds work properly.
  late bool _hasScale9Grid;
  double _buffScaleX = 0.0, _buffScaleY = 0.0;
  final GRect _cachedBounds = GRect();
  final _paint = ui.Paint()..filterQuality = ui.FilterQuality.medium;
  ui.Paint get nativePaint => _paint;

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

  set texture(GTexture? value) {
    if (_texture == value) return;
    _texture = value;
    if (_texture != null) {
      pivotX = -_texture!.pivotX! + $originalPivotX;
      pivotY = -_texture!.pivotY! + $originalPivotY;
    }
    requiresRedraw();
  }

  GBitmap([GTexture? texture]) {
    this.texture = texture;
  }

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

  @override
  set alpha(double value) {
    super.alpha = value;
    _paint.color = _paint.color.withOpacity($alpha);
  }

  @override
  set colorize(ui.Color? value) {
    if ($colorize == value) return;
    super.colorize = value;
    _paint.colorFilter =
        $hasColorize ? PainterUtils.getColorize($colorize!) : null;
  }

  @override
  set filters(List<GBaseFilter>? value) {
    if ($filters == value) return;
    $filters = value;
    if ($filters == null) {
      _paint.imageFilter = null;
      _paint.maskFilter = null;
    }
  }

  @override
  void paint(ui.Canvas canvas) {
    if (texture == null) return;
    _hasScale9Grid = texture!.scale9Grid != null;
    if (_hasScale9Grid) {
      _adjustScaleGrid();
    }
    super.paint(canvas);
  }

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
    if (_hasScale9Grid) setScale(_buffScaleX, _buffScaleY);
  }

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
