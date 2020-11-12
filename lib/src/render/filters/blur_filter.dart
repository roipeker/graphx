import 'dart:ui';

import '../../../graphx.dart';

class BaseFilter {
  void resolvePaint(Paint paint) {}

  bool dirty = false;
  void update() {
    if (dirty) {
      dirty = false;
      if (isValid) {
        buildFilter();
      }
    }
  }

  void buildFilter() {}
  bool get isValid => true;

  void expandBounds(GxRect layerBounds, GxRect outputBounds) {}
}

class BlurFilter extends BaseFilter {
  double _blurX = 0;
  double _blurY = 0;

  /// -1 = autodetect from blur..
  double maskSigma = -1;

  BlurStyle style = BlurStyle.inner;

  double get blurX => _blurX;
  double get blurY => _blurY;
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

  BlurFilter([double blurX = 0, double blurY = 0]) {
    this.blurX = blurX;
    this.blurY = blurY;
  }

  MaskFilter _maskFilter;
  ImageFilter _imageFilter;
  final _rect = GxRect();
  GxRect get filterRect => _rect;

  @override
  void expandBounds(GxRect layerBounds, GxRect outputBounds) {
    _rect.copyFrom(layerBounds).inflate(blurX, blurY);
    outputBounds.expandToInclude(_rect);
  }

  @override
  bool get isValid => _blurX > 0 || _blurY > 0;

  @override
  void buildFilter() {
    double maxBlur = maskSigma;
    if (maxBlur == -1) {
      maxBlur = max(_blurX, _blurY) / 2;
      if (maxBlur < 1) maxBlur = 1;
    }

    /// if it goes under a threshold (I tried .2 and lower), it flickers.
    /// idk which logic uses, but 1.0 seems like a stable min number for the mask
    _maskFilter = MaskFilter.blur(style ?? BlurStyle.inner, maxBlur);
    _imageFilter = ImageFilter.blur(sigmaX: _blurX, sigmaY: _blurY);
  }

  @override
  void resolvePaint(Paint paint) {
    if (!isValid) return;
    paint.imageFilter = _imageFilter;
    paint.maskFilter = _maskFilter;
  }

// double blur = 8;
// final paint = Paint();
// paint.imageFilter = ImageFilter.blur(sigmaX: blur, sigmaY: blur);
// paint.maskFilter = MaskFilter.blur(BlurStyle.solid, blur / 2);
}
