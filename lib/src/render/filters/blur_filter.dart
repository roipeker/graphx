import 'dart:ui' as ui;

import '../../../graphx.dart';

class GBlurFilter extends GBaseFilter {
  double _blurX = 0;
  double _blurY = 0;

  /// -1 = autodetect from blur..
  double maskSigma = -1;

  ui.BlurStyle style = ui.BlurStyle.inner;

  double get blurX => _blurX;
  double get blurY => _blurY;
  set blurX(double value) {
    if (_blurX == value) return;
    _blurX = Math.max(value, 0);
    dirty = true;
  }

  set blurY(double value) {
    if (_blurY == value) return;
    _blurY = Math.max(value, 0);
    dirty = true;
  }

  GBlurFilter([double blurX = 0, double blurY = 0]) {
    this.blurX = blurX;
    this.blurY = blurY;
  }

  ui.MaskFilter? _maskFilter;
  ui.ImageFilter? _imageFilter;
  final _rect = GRect();
  GRect get filterRect => _rect;

  @override
  void expandBounds(GRect layerBounds, GRect outputBounds) {
    _rect.copyFrom(layerBounds).inflate(blurX, blurY);
    outputBounds.expandToInclude(_rect);
  }

  @override
  bool get isValid => _blurX > 0 || _blurY > 0;

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
    _maskFilter = ui.MaskFilter.blur(style, maxBlur);
    _imageFilter = ui.ImageFilter.blur(sigmaX: _blurX, sigmaY: _blurY);
  }

  @override
  void resolvePaint(ui.Paint paint) {
    if (!isValid) return;
    paint.filterQuality = ui.FilterQuality.low;
    paint.imageFilter = _imageFilter;
    paint.maskFilter = _maskFilter;
  }

// double blur = 8;
// final paint = Paint();
// paint.imageFilter = ImageFilter.blur(sigmaX: blur, sigmaY: blur);
// paint.maskFilter = MaskFilter.blur(BlurStyle.solid, blur / 2);
}
