import 'dart:ui';

import '../../graphx.dart';
import '../utils/utils.dart';

class GSvgShape extends GDisplayObject {
  static final GMatrix _sHelperMatrix = GMatrix();
  static final GPoint _sHelperPoint = GPoint();

  Color _tint;

  /// play nice with Colorization.
  BlendMode _blendMode = BlendMode.srcATop;

  /// or modulate.

  bool _invalidColor = false;

  Color get tint => _tint;

  set tint(Color value) {
    _tint = value;
    _invalidColor = true;
    usePaint = true;
    requiresRedraw();
  }

  BlendMode get blendMode => _blendMode;

  set blendMode(BlendMode value) {
    _blendMode = value;
    _invalidColor = true;
    usePaint = true;
    requiresRedraw();
  }

  @override
  String toString() {
    final msg = name != null ? ' {name: $name}' : '';
    return '$runtimeType (SvgShape)$msg';
  }

  bool _isValid = false;
  SvgData _data;

  SvgData get data => _data;

  set data(SvgData value) {
    if (_data == value) return;
    _data = value;
    _isValid = _data?.hasContent ?? false;
    requiresRedraw();
  }

  GSvgShape(SvgData data) {
    this.data = data;
  }

  GSvgShape clone() {
    var obj = GSvgShape(data);
    obj._blendMode = _blendMode;
    obj._tint = _tint;
    obj.$alpha = $alpha;
    obj.transformationMatrix = transformationMatrix;
    return obj;
  }

  @override
  GRect getBounds(GDisplayObject targetSpace, [GRect out]) {
    final matrix = _sHelperMatrix;
    matrix.identity();
    getTransformationMatrix(targetSpace, matrix);
    if (_isValid) {
      var r = _data.size;
      out = MatrixUtils.getTransformedBoundsRect(
        matrix,
        r,
        out,
      );
    } else {
      matrix.transformCoords(0, 0, _sHelperPoint);
      out.setTo(_sHelperPoint.x, _sHelperPoint.y, 0, 0);
    }
    return out;
  }

  final _paint = Paint();

  Paint get nativePaint => _paint;
  bool usePaint = false;

  @override
  set alpha(double value) {
    super.alpha = value;
    _paint.color = _paint.color.withOpacity($alpha);
  }

  @override
  void paint(Canvas canvas) {
    if (!_isValid) return;
    super.paint(canvas);
  }

  @override
  void $applyPaint(Canvas canvas) {
    var _saveLayer = $alpha != 1 || usePaint;
    if (_saveLayer) {
      if (_invalidColor) _validateColor();
      final rect = getBounds(this).toNative();
      canvas.saveLayer(rect, _paint);
    }
    canvas.drawPicture(_data.picture);
    if (_saveLayer) {
      canvas.restore();
    }
  }

  void _validateColor() {
    _paint.colorFilter = ColorFilter.mode(_tint, _blendMode);
    _invalidColor = false;
  }
}

/// proxy class to flutter_svg
class SvgData {
  Color color;
  GRect viewBox;
  GRect size;
  Picture picture;
  bool hasContent;

  SvgData([this.picture]);

  void dispose() {
    picture?.dispose();
    picture = null;
    hasContent = false;
  }
}
