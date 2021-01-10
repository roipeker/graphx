import 'dart:ui';

import '../../../graphx.dart';
import 'composer_filter.dart';

class GlowFilter extends ComposerFilter {
  double _blurX = 0;
  double _blurY = 0;
  Color _color = kColorRed;
  // todo: find a way to define the strength of the filter.
  double _strength = 0.0;

  /// Number of iterations to apply the same filter. Bigger
  /// value, value more stressed.
  int iterations = 1;

  double maskSigma = -1;
  BlurStyle style = BlurStyle.inner;
  double get blurX => _blurX;
  double get blurY => _blurY;
  Color get color => _color;

  set color(Color value) {
    if (_color == value) return;
    _color = value ?? kColorBlack;
    dirty = true;
  }

  set blurX(double value) {
    if (_blurX == value) return;
    _blurX = max(value, 0);
    dirty = true;
  }

  set blurY(double value) {
    if (_blurY == value) return;
    _blurY = max(value, 0);
    dirty = true;
  }

  GlowFilter([
    double blurX = 0,
    double blurY = 0,
    Color color = kColorRed,
    bool hideObject = false,
  ]) {
    this.blurX = blurX;
    this.blurY = blurY;
    this.color = color;
    this.hideObject = hideObject;
  }

  ColorFilter _colorFilter;
  MaskFilter _maskFilter;
  ImageFilter _imageFilter;

  final _rect = GxRect();
  GxRect get filterRect => _rect;
  // GxRect _outBounds;
  @override
  void expandBounds(GxRect layerBounds, GxRect outputBounds) {
    super.expandBounds(layerBounds, outputBounds);
    _rect.copyFrom(layerBounds).inflate(blurX * 2, blurY * 2);
    // trace('outputBounds', outputBounds);
    outputBounds.expandToInclude(_rect);
    // _outBounds = outputBounds;
  }

  @override
  bool get isValid =>
      _blurX > 0 || _blurY > 0 && color.value != kColorTransparent.value;

  @override
  void buildFilter() {
    var maxBlur = maskSigma;
    if (maxBlur == -1) {
      maxBlur = max(_blurX, _blurY) / 2;
      if (maxBlur < 1) maxBlur = 1;
    }
    _maskFilter = MaskFilter.blur(style ?? BlurStyle.normal, maxBlur);
    _imageFilter = ImageFilter.blur(sigmaX: _blurX, sigmaY: _blurY);
    _colorFilter = ColorFilter.mode(_color.withAlpha(255), BlendMode.srcATop);
    paint.imageFilter = _imageFilter;
    paint.maskFilter = _maskFilter;
    paint.colorFilter = _colorFilter;
    if (_color.alpha < 255) {
      paint.color = _color;
    }
  }

  // var _iterations = 0;

  @override
  void process(Canvas canvas, Function applyPaint, [int processCount = 1]) {
    // trace('rect is: ', _outBounds);
    // var a = GxRect(0, 0, layerBounds.width - layerBounds.x,
    //     layerBounds.height - layerBounds.y);
    // trace(layerBounds, _rect);
    // canvas.saveLayer(layerBounds.toNative(), paint);
    canvas.saveLayer(null, paint);
    applyPaint(canvas);
    canvas.restore();
    if (++processCount <= iterations) {
      process(canvas, applyPaint, processCount);
    }
  }
}
