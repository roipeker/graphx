import 'dart:ui';

import '../../../graphx.dart';

/// A filter that applies a glow effect to an object.
/// This filter is similar to a [DropShadowFilter] with a [BlurStyle.outer]
/// [MaskFilter] applied.
class GlowFilter extends GComposerFilter {
  /// The blur value for the horizontal axis.
  double _blurX = 0;

  /// The blur value for the vertical axis.
  double _blurY = 0;

  /// The color of the glow effect.
  Color _color = kColorRed;

  /// Number of iterations to apply the same filter. Bigger value, value more
  /// stressed.
  int iterations = 1;

  /// The mask sigma value for the filter.
  double maskSigma = -1;

  /// The blur style of the filter.
  BlurStyle style = BlurStyle.inner;

  /// A [ColorFilter] that applies the current [_color] to the image with the
  /// [BlendMode.srcATop] mode.
  ///
  /// If [_color] has an alpha value less than 255, the [paint] color is set to
  /// [_color] and the [BlendMode.srcOver] mode is applied to the image.
  ColorFilter? _colorFilter;

  /// The mask filter used for blurring the glow.
  MaskFilter? _maskFilter;

  /// [ImageFilter] object for this filter using the blur values for the glow
  /// on the x and y axes. Sets the [sigmaX] and [sigmaY] values to the maximum
  /// between the actual blur value and a minimum value of 0.02.
  ImageFilter? _imageFilter;

  /// The rectangle that defines the area of the filter effect.
  final _rect = GRect();

  /// Creates a new instance of [GlowFilter].
  ///
  /// The [blurX] is the blue value for the filter on the x-axis.
  /// The [blurY] is the blur value for the filter on the y-axis.
  /// The [color] is the  color of the filter.
  /// If [hideObject] is `true`, the object that the filter is applied to will
  /// be hidden.
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

  /// The blur value for the filter on the x-axis.
  double get blurX => _blurX;

  /// Sets the blur value for the filter on the x-axis.
  set blurX(double value) {
    if (_blurX == value) return;
    _blurX = Math.max(value, 0);
    dirty = true;
  }

  /// The blur value for the filter on the y-axis.
  double get blurY => _blurY;

  /// Sets the blur value for the filter on the y-axis.
  set blurY(double value) {
    if (_blurY == value) return;
    _blurY = Math.max(value, 0);
    dirty = true;
  }

  /// The color value for the filter.
  Color get color => _color;

  /// Sets the color value for the filter.
  set color(Color? value) {
    if (_color == value) return;
    _color = value ?? kColorBlack;
    dirty = true;
  }

  /// Returns the filter rectangle bounding area.
  GRect get filterRect {
    return _rect;
  }

  /// (Internal usage)
  /// Checks if the filter is valid and should be applied.
  ///
  /// A filter is considered valid if it has a positive blur on either the x or
  /// y axis, and its color is not fully transparent.
  @override
  bool get isValid {
    return _blurX > 0 || _blurY > 0 && color != kColorTransparent;
  }

  /// (Internal usage)
  /// Constructs and sets the filters used by this [GlowFilter].
  ///
  /// Builds the color, mask, and image filters based on the current
  /// values of [_blurX], [_blurY], and [_color], and sets them on
  /// the [paint] object used by this filter.
  @override
  void buildFilter() {
    var maxBlur = maskSigma;
    if (maxBlur == -1) {
      maxBlur = Math.max(_blurX, _blurY) / 2;
      if (maxBlur < 1) maxBlur = 1;
    }
    _maskFilter = MaskFilter.blur(style, maxBlur);
    _imageFilter = ImageFilter.blur(sigmaX: _blurX, sigmaY: _blurY);
    _colorFilter = ColorFilter.mode(
      _color.withAlpha(255),
      BlendMode.srcATop,
    );
    paint.imageFilter = _imageFilter;
    paint.maskFilter = _maskFilter;
    paint.colorFilter = _colorFilter;
    if (_color.alpha < 255) {
      paint.color = _color;
    }
  }

  /// Expands the [layerBounds] by blurX * 2 and blurY * 2 and copies the result
  /// to the bounds rect. Then expands the [outputBounds] to include `_rect`
  @override
  void expandBounds(GRect layerBounds, GRect outputBounds) {
    super.expandBounds(layerBounds, outputBounds);
    _rect.copyFrom(layerBounds).inflate(blurX * 2, blurY * 2);
    // trace('outputBounds', outputBounds);
    outputBounds.expandToInclude(_rect);
    // _outBounds = outputBounds;
  }

  /// Applies the glow filter to the [canvas] using the [applyPaint] function,
  /// with the given number of [iterations]. Each iteration applies the same
  /// filter, resulting in a stronger effect.
  ///
  /// If [canvas] is null, the method does nothing.
  ///
  /// The optional parameter [processCount] indicates how many times this method
  /// has been called recursively. It defaults to 1, meaning that it's the first
  /// iteration.
  @override
  void process(Canvas? canvas, Function applyPaint, [int processCount = 1]) {
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
