import 'dart:ui';

import '../../../graphx.dart';
import 'composer_filter.dart';

class GDropShadowFilter extends GComposerFilter {
  double _blurX = 0;
  double _blurY = 0;
  double _angle = 0;
  double _distance = 0;
  Color _color = kColorBlack;
  // todo: find a way to define the strength of the filter.
  // double _strength = 0.0;

  /// Number of iterations to apply the same filter. Bigger
  /// value, value more stressed.
  int iterations = 1;

  /// -1 = autodetect from blur..
  double maskSigma = -1;
  BlurStyle style = BlurStyle.inner;

  double get blurX => _blurX;
  double get blurY => _blurY;
  double get angle => _angle;
  double get distance => _distance;
  Color get color => _color;

  double _dx = 0, _dy = 0;
  set color(Color value) {
    if (_color == value) return;
    _color = value ?? kColorBlack;
    dirty = true;
  }

  set angle(double value) {
    if (_angle == value) return;
    _angle = value % Math.PI_2;
    _calculatePosition();
    dirty = true;
  }

  set distance(double value) {
    value ??= 0;
    if (_distance == value) return;
    _distance = value;
    _calculatePosition();
    dirty = true;
  }

  void _calculatePosition() {
    _dx = Math.cos(_angle) * _distance;
    _dy = Math.sin(_angle) * _distance;
  }

  set blurX(double value) {
    if (_blurX == value) return;
    _blurX = Math.max(value, 0.02);
    dirty = true;
  }

  set blurY(double value) {
    if (_blurY == value) return;
    _blurY = Math.max(value, 0.02);
    dirty = true;
  }

  GDropShadowFilter([
    double blurX = 0,
    double blurY = 0,
    double angle = 0,
    double distance = 0,
    Color color = kColorBlack,
    bool hideObject = false,
  ]) {
    this.blurX = blurX;
    this.blurY = blurY;
    this.angle = angle;
    this.distance = distance;
    this.color = color;
    this.hideObject = hideObject;
  }

  ColorFilter _colorFilter;
  MaskFilter _maskFilter;
  ImageFilter _imageFilter;

  final _rect = GRect();
  GRect get filterRect => _rect;

  @override
  void expandBounds(GRect layerBounds, GRect outputBounds) {
    super.expandBounds(layerBounds, outputBounds);
    _rect.copyFrom(layerBounds).inflate(blurX, blurY);
    outputBounds.expandToInclude(_rect);
    // trace(layerBounds);
    // _rect.copyFrom(layerBounds).inflate(blurX, blurY);
    // outputBounds.expandToInclude(_rect);
    // return outputBounds;
  }

  @override
  bool get isValid =>
      _blurX > 0 || _blurY > 0 && color.value != kColorTransparent.value;

  /// todo: Check why lower numbers brings the layer on top creating a glitch.
  static const double _minBlur = .02;

  @override
  void buildFilter() {
    var maxBlur = maskSigma;
    if (maxBlur == -1) {
      maxBlur = Math.max(_blurX, _blurY) / 2;
      if (maxBlur < 1) maxBlur = 1;
    }

    /// if it goes under a threshold (I tried .2 and lower), it flickers.
    /// idk which logic uses, but 1.0 seems like a stable min number for the
    /// mask.
    _maskFilter = MaskFilter.blur(style ?? BlurStyle.inner, maxBlur);
    _imageFilter = ImageFilter.blur(
      sigmaX: Math.max(_blurX, _minBlur),
      sigmaY: Math.max(_blurY, _minBlur),
    );
    _colorFilter = ColorFilter.mode(_color.withAlpha(255), BlendMode.srcATop);
    paint.imageFilter = _imageFilter;
    paint.maskFilter = _maskFilter;
    paint.colorFilter = _colorFilter;
    if (_color.alpha < 255) {
      paint.color = _color;
    }
  }

  @override
  void process(Canvas canvas, Function applyPaint, [int processCount = 1]) {
    canvas.saveLayer(null, paint);
    // final bb = layerBounds.clone();
    // bb.inflate(_strength, _strength);
    canvas.translate(_dx, _dy);
    applyPaint(canvas);
    canvas.restore();
    if (++processCount <= iterations) {
      process(canvas, applyPaint, processCount);
    }
  }
}
