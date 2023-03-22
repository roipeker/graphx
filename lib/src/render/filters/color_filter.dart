import 'dart:ui';

import '../../geom/grect.dart';
import 'base_filter.dart';

/// A collection of predefined color filter effects.
abstract class GColorFilters {
  /// A color filter that inverts the colors of the content.
  ///
  /// This filter applies a color matrix that negates all three color channels
  /// and inverts the alpha channel, effectively inverting the colors of the
  /// content.
  static const ColorFilter invert = ColorFilter.matrix(<double>[
    -1, 0, 0, 0, 255, //
    0, -1, 0, 0, 255, //
    0, 0, -1, 0, 255, //
    0, 0, 0, 1, 0, //
  ]);

  /// A color filter that applies a sepia tone to the content.
  ///
  /// This filter applies a color matrix that reduces the green and blue color
  /// channels, while enhancing the red color channel, giving the content a
  /// sepia tone.
  static const ColorFilter sepia = ColorFilter.matrix(<double>[
    0.393, 0.769, 0.189, 0, 0, //
    0.349, 0.686, 0.168, 0, 0, //
    0.272, 0.534, 0.131, 0, 0, //
    0, 0, 0, 1, 0, //
  ]);

  /// A color filter that converts the content to grayscale.
  ///
  /// This filter applies a color matrix that sets all three color channels to
  /// the average of the original pixel value, effectively converting the
  /// content to grayscale.
  static const ColorFilter greyscale = ColorFilter.matrix(<double>[
    0.2126, 0.7152, 0.0722, 0, 0, //
    0.2126, 0.7152, 0.0722, 0, 0, //
    0.2126, 0.7152, 0.0722, 0, 0, //
    0, 0, 0, 1, 0 //
  ]);

  /// A color filter that applies a psychedelic effect to the content.
  ///
  /// This filter applies a color matrix that enhances the red and blue color
  /// channels while reducing the green color channel, giving the content a
  /// psychedelic effect.
  static const ColorFilter lsd = ColorFilter.matrix(<double>[
    2, -0.4, 0.5, 0, 0, //
    -0.5, 2, -0.4, 0, 0, //
    -0.4, -0.5, 3, 0, 0, //
    0, 0, 0, 1, 0,
  ]);

  /// A color filter that applies a vintage effect to the content.
  ///
  /// This filter applies a color matrix that reduces the green and blue color
  /// channels, while enhancing the red color channel, and applies a slight
  /// vignette to the content, giving it a vintage, aged appearance.
  static const ColorFilter vintage = ColorFilter.matrix(<double>[
    //
    0.6279345635605994, 0.3202183420819367, -0.03965408211312453, 0,
    9.651285835294123,
    //
    0.02578397704808868, 0.6441188644374771, 0.03259127616149294, 0,
    7.462829176470591,
    //
    0.0466055556782719, -0.0851232987247891, 0.5241648018700465, 0,
    5.159190588235296,
    //
    0, 0, 0, 1, 0,
  ]);
}

/// A color matrix filter that applies a [ColorFilter] effect to the content.
class GColorMatrixFilter extends GBaseFilter {
  /// The color filter effect to apply to the content.
  ColorFilter? colorFilter;

  /// The rectangle that defines the filter's bounds.
  final _rect = GRect();

  /// Creates a new [GColorMatrixFilter] with the given color filter.
  GColorMatrixFilter(this.colorFilter);

  /// Returns the filter's rectangle.
  GRect get filterRect {
    return _rect;
  }

  /// Checks if the filter has any effect to apply.
  ///
  /// Returns `true` if the filter has any effect to apply, `false` otherwise.
  @override
  bool get isValid {
    return colorFilter != null;
  }

  /// Sets the paint's color filter to the [colorFilter] effect.
  ///
  /// The [paint] parameter is the paint object to apply the filter to.
  ///
  /// If the filter is not valid, i.e., [isValid] returns false, this method
  /// does nothing.
  @override
  void resolvePaint(Paint paint) {
    if (!isValid) return;
    paint.colorFilter = colorFilter;
  }
}
