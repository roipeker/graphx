import 'dart:ui';

import '../../../graphx.dart';

/// A filter that applies a drop shadow effect to the target display object.
class GDropShadowFilter extends GComposerFilter {
  // The following properties define the parameters of the drop shadow effect.

  /// The minimum value for the blur radius. If the blur value goes under this
  /// threshold, it can cause a flickering effect.
  /// TODO: Check why lower numbers brings the layer on top creating a glitch.
  static const double _minBlur = .02;

  /// The blur value for the shadow on the x-axis.
  double _blurX = 0;

  /// The blur value for the shadow on the y-axis.
  double _blurY = 0;

  /// The angle of the shadow, in radians.
  double _angle = 0;

  /// The distance between the object and the shadow.
  double _distance = 0;

  /// The color of the shadow.
  Color _color = kColorBlack;

  /// Determines whether the shadow is an inner shadow (true) or an outer shadow
  /// (false). Inner shadows appear inside the boundaries of the object, while
  /// outer shadows appear outside.
  bool innerShadow = false;

  /// An integer that represents the number of iterations to apply the
  /// same filter. The bigger the value, the more stressed the shadow will be.
  /// By default, it's set to 1.
  int iterations = 1;

  /// A double that represents the value of the blur
  /// sigma. When set to -1 (default), it will be automatically detected from
  /// the blurX and blurY values. Otherwise, it will be set to the provided
  /// value.
  double maskSigma = -1;

  /// The style of blur to apply to the shadow.
  BlurStyle style = BlurStyle.inner;

  /// The x and y coordinates of the shadow, calculated based on the current
  /// angle and distance values. These values are used to translate the canvas
  /// before applying the shadow.
  double _dx = 0;

  double _dy = 0;

  /// A [ColorFilter] that applies the current [_color] to the image with the
  /// [BlendMode.srcATop] mode.
  ///
  /// If [_color] has an alpha value less than 255, the [paint] color is set to
  /// [_color] and the [BlendMode.srcOver] mode is applied to the image.
  ColorFilter? _colorFilter;

  /// The mask filter used for blurring the shadow.
  MaskFilter? _maskFilter;

  /// [ImageFilter] object for this filter using the blur values for the shadow
  /// on the x and y axes. Sets the [sigmaX] and [sigmaY] values to the maximum
  /// between the actual blur value and a minimum value of 0.02.
  ImageFilter? _imageFilter;

  /// The rectangle that defines the area of the filter effect.
  final _rect = GRect();

  /// Creates a new instance of `GDropShadowFilter`.
  ///
  /// The `blurX` parameter specifies the blur value for the shadow on the
  /// x-axis.
  ///
  /// The `blurY` parameter specifies the blur value for the shadow on the
  /// y-axis.
  ///
  /// The `angle` parameter specifies the angle of the shadow, in radians.
  ///
  /// The `distance` parameter specifies the distance between the object and the
  /// shadow.
  ///
  /// The `color` parameter specifies the color of the shadow.
  ///
  /// The `hideObject` parameter specifies whether or not the object being
  /// shadowed should be hidden.
  ///
  /// The `innerShadow` parameter specifies whether or not the shadow should be
  /// an inner shadow.
  GDropShadowFilter([
    double blurX = 0,
    double blurY = 0,
    double angle = 0,
    double distance = 0,
    Color color = kColorBlack,
    bool hideObject = false,
    this.innerShadow = false,
  ]) {
    this.blurX = blurX;
    this.blurY = blurY;
    this.angle = angle;
    this.distance = distance;
    this.color = color;
    this.hideObject = hideObject;
  }

  /// The angle of the shadow, in radians.
  double get angle {
    return _angle;
  }

  /// Sets the shadow angle, in radians.
  set angle(double angle) {
    if (_angle == angle) return;
    _angle = angle % Math.PI_2;
    _calculatePosition();
    dirty = true;
  }

  /// The blur value for the shadow on the x-axis.
  double get blurX {
    return _blurX;
  }

  /// Sets the blur value for the shadow on the x-axis.
  set blurX(double blur) {
    if (_blurX == blur) {
      return;
    }
    _blurX = Math.max(blur, 0.02);
    dirty = true;
  }

  /// The blur value for the shadow on the y-axis.
  double get blurY {
    return _blurY;
  }

  /// Sets the blur value for the shadow on the y-axis.
  set blurY(double blur) {
    if (_blurY == blur) {
      return;
    }
    _blurY = Math.max(blur, 0.02);
    dirty = true;
  }

  /// The color of the shadow.
  Color get color {
    return _color;
  }

  /// Sets the shadow color.
  set color(Color? color) {
    if (_color == color) {
      return;
    }
    _color = color ?? kColorBlack;
    dirty = true;
  }

  /// The distance between the object and the shadow.
  double get distance {
    return _distance;
  }

  /// Sets the shadow distance.
  set distance(double distance) {
    if (_distance == distance) {
      return;
    }
    _distance = distance;
    _calculatePosition();
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
    return _blurX > 0 || _blurY > 0 && color.value != kColorTransparent.value;
  }

  /// (Internal usage)
  /// Constructs the various filters used by this drop shadow filter, such as
  /// the mask filter, image filter, and color filter. Applies these filters to
  /// the [paint] object.
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
    _maskFilter = MaskFilter.blur(style, maxBlur);
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

  /// (Internal usage)
  /// Expands the filter's bounds to include any additional area needed to
  /// accommodate the drop shadow effect, as determined by the current blur
  /// radius.
  ///
  /// The [layerBounds] parameter specifies the bounds of the object being
  /// filtered, while the [outputBounds] parameter specifies the overall bounds
  /// of the filter that should include any additional space required for the
  /// shadow.
  ///
  /// This implementation calculates the new filter bounds by copying the layer
  /// bounds and inflating it to include the size of the shadow. The shadow size
  /// is determined by the current [blurX] and [blurY] values. Once the filter
  /// bounds have been calculated, they are expanded to include any additional
  /// area required to accommodate the shadow, and the updated bounds are stored
  /// in the [outputBounds] parameter.
  ///
  /// The updated bounds are stored in the [outputBounds] parameter.
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

  /// (Internal usage)
  ///
  /// Applies the filter effect to the specified [canvas].
  ///
  /// The filter effect is applied by saving the canvas layer, translating the
  /// canvas to the shadow's position, applying the paint with the filter, and
  /// then restoring the canvas layer. If the [innerShadow] property is set to
  /// true, additional canvas layers are saved to render the inner shadow.
  ///
  /// [applyPaint] is a callback function that applies the paint with the filter
  /// effect to the canvas.
  ///
  /// If the [iterations] property is greater than 1, the [process] method will
  /// recursively apply the filter effect to the canvas the specified number of
  /// times, each time with the original layer as the base layer.
  ///
  /// [processCount] is an optional parameter that specifies the current
  /// iteration count for the filter effect. This parameter is used internally
  /// by the [process] method when calling itself recursively and should not be
  /// passed in by the caller.
  @override
  void process(Canvas canvas, Function applyPaint, [int processCount = 1]) {
    /// compute outer rect.
    if (innerShadow) {
      /// TODO: rework logic for bounds.
      /// todo: too many save layer calls for inner shadows.
      ///
      // var rectOuter = _rect.clone();
      // rectOuter.x= rectOuter.y=0;
      // var rectInner = rectOuter.clone();
      // rectInner.width = rectOuter.width-_dx;
      // rectInner.height = rectOuter.height-_dy;
      canvas.saveLayer(null, Paint());
      applyPaint(canvas);
      final shadowPaint = Paint()
        ..blendMode = BlendMode.srcATop
        ..imageFilter = ImageFilter.blur(sigmaX: blurX, sigmaY: blurY)
        ..colorFilter = ColorFilter.mode(color, BlendMode.srcOut);
      canvas.saveLayer(null, shadowPaint);
      canvas.saveLayer(null, Paint());
      canvas.translate(_dx, _dy);
      applyPaint(canvas);
      canvas.restore();
      canvas.restore();
      canvas.restore();
    } else {
      canvas.saveLayer(null, paint);
      // final bb = layerBounds.clone();
      // bb.inflate(_strength, _strength);
      canvas.translate(_dx, _dy);
      applyPaint(canvas);
      canvas.restore();
    }
    if (++processCount <= iterations) {
      process(canvas, applyPaint, processCount);
    }
  }

  /// Calculates the position of the shadow based on the angle and distance.
  void _calculatePosition() {
    _dx = Math.cos(_angle) * _distance;
    _dy = Math.sin(_angle) * _distance;
  }
}
