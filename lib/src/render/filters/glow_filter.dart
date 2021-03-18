import 'dart:ui' as ui;
import '../../../graphx.dart';
import 'composer_filter.dart';

class GlowFilter extends GComposerFilter {
  double _blurX = 0;
  double _blurY = 0;
  ui.Color _color = kColorRed;

  // todo: find a way to define the strength of the filter.
  // double _strength = 0.0;

  /// Number of iterations to apply the same filter. Bigger
  /// value, value more stressed.
  int iterations = 1;

  double maskSigma = -1;
  ui.BlurStyle style = ui.BlurStyle.inner;

  double get blurX => _blurX;

  double get blurY => _blurY;

  ui.Color get color => _color;

  set color(ui.Color? value) {
    if (_color == value) return;
    _color = value ?? kColorBlack;
    dirty = true;
  }

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

  GlowFilter([
    double blurX = 0,
    double blurY = 0,
    ui.Color color = kColorRed,
    bool hideObject = false,
  ]) {
    this.blurX = blurX;
    this.blurY = blurY;
    this.color = color;
    this.hideObject = hideObject;
  }

  ui.ColorFilter? _colorFilter;
  ui.MaskFilter? _maskFilter;
  ui.ImageFilter? _imageFilter;

  final _rect = GRect();

  GRect get filterRect => _rect;

  // GxRect _outBounds;
  @override
  void expandBounds(GRect layerBounds, GRect outputBounds) {
    super.expandBounds(layerBounds, outputBounds);
    _rect.copyFrom(layerBounds).inflate(blurX * 2, blurY * 2);
    // trace('outputBounds', outputBounds);
    outputBounds.expandToInclude(_rect);
    // _outBounds = outputBounds;
  }

  @override
  bool get isValid => _blurX > 0 || _blurY > 0 && color != kColorTransparent;

  @override
  void buildFilter() {
    var maxBlur = maskSigma;
    if (maxBlur == -1) {
      maxBlur = Math.max(_blurX, _blurY) / 2;
      if (maxBlur < 1) maxBlur = 1;
    }
    _maskFilter = ui.MaskFilter.blur(style, maxBlur);
    _imageFilter = ui.ImageFilter.blur(sigmaX: _blurX, sigmaY: _blurY);
    _colorFilter = ui.ColorFilter.mode(
      _color.withAlpha(255),
      ui.BlendMode.srcATop,
    );
    paint.imageFilter = _imageFilter;
    paint.maskFilter = _maskFilter;
    paint.colorFilter = _colorFilter;
    if (_color.alpha < 255) {
      paint.color = _color;
    }
  }

  // var _iterations = 0;

  @override
  void process(ui.Canvas? canvas, Function applyPaint, [int processCount = 1]) {
    // trace('rect is: ', _outBounds);
    // var a = GxRect(0, 0, layerBounds.width - layerBounds.x,
    //     layerBounds.height - layerBounds.y);
    // trace(layerBounds, _rect);
    // canvas.saveLayer(layerBounds.toNative(), paint);
    canvas!.saveLayer(null, paint);
    applyPaint(canvas);
    canvas.restore();
    if (++processCount <= iterations) {
      process(canvas, applyPaint, processCount);
    }
  }
}
