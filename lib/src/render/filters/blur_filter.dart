import 'dart:ui' as ui;

import '../../../graphx.dart';

/// A filter that applies a blur effect to the content.
class GBlurFilter extends GBaseFilter {
  /// The amount of horizontal blur to apply.
  double _blurX = 0;

  /// The amount of vertical blur to apply.
  double _blurY = 0;

  /// The standard deviation of the Gaussian blur mask filter.
  /// When it's -1 it will autodetect from blur.
  double maskSigma = -1;

  /// The type of the [ui.BlurStyle] blur.
  ui.BlurStyle style = ui.BlurStyle.inner;

  /// The blur mask filter used to create the Gaussian blur effect.
  ui.MaskFilter? _maskFilter;

  /// The image filter used to create the Gaussian blur effect.
  ui.ImageFilter? _imageFilter;

  /// The rectangle that defines the filter's bounds.
  final _rect = GRect();

  /// Creates a new [GBlurFilter] with the given blur values.
  GBlurFilter([double blurX = 0, double blurY = 0]) {
    this.blurX = blurX;
    this.blurY = blurY;
  }

  /// Returns the value of [_blurX].
  double get blurX {
    return _blurX;
  }

  /// Sets the value of [_blurX] to the given [blur].
  set blurX(double blur) {
    if (_blurX == blur) {
      return;
    }
    _blurX = Math.max(blur, 0);
    dirty = true;
  }

  /// Returns the value of [_blurY].
  double get blurY {
    return _blurY;
  }

  /// Sets the value of [_blurY] to the given [blur].
  set blurY(double blur) {
    if (_blurY == blur) {
      return;
    }
    _blurY = Math.max(blur, 0);
    dirty = true;
  }

  /// Returns the filter's rectangle.
  GRect get filterRect {
    return _rect;
  }

  /// Checks if the filter has any effect to apply.
  ///
  /// Returns `true` if either [blurX] or [blurY] is greater than zero,
  /// `false` otherwise.
  @override
  bool get isValid {
    return _blurX > 0 || _blurY > 0;
  }

  /// Builds the mask filter and image filter for the blur effect.
  ///
  /// This method is called when the filter is marked as dirty and needs to be
  /// updated.
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

  /// Expands the filter's bounds to include the blur effect.
  ///
  /// The [layerBounds] parameter is the original bounds of the content.
  ///
  /// The [outputBounds] parameter is the expanded bounds of the filter.
  @override
  void expandBounds(GRect layerBounds, GRect outputBounds) {
    _rect.copyFrom(layerBounds).inflate(blurX, blurY);
    outputBounds.expandToInclude(_rect);
  }

  /// Sets the paint's filter quality, image filter, and mask filter for the
  /// blur effect.
  ///
  /// The [paint] parameter is the paint object to apply the filter to.
  ///
  /// If the filter is not valid, i.e., [isValid] returns `false`, this method
  /// does nothing.
  @override
  void resolvePaint(ui.Paint paint) {
    if (!isValid) {
      return;
    }
    paint.filterQuality = ui.FilterQuality.low;
    paint.imageFilter = _imageFilter;
    paint.maskFilter = _maskFilter;
  }
}
