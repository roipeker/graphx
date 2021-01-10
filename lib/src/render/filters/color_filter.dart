import 'dart:ui';

import 'package:graphx/src/geom/gxrect.dart';

import 'blur_filter.dart';

class ColorFilters {
  static const ColorFilter invert = ColorFilter.matrix(<double>[
    -1,
    0,
    0,
    0,
    255,
    0,
    -1,
    0,
    0,
    255,
    0,
    0,
    -1,
    0,
    255,
    0,
    0,
    0,
    1,
    0,
  ]);

  static const ColorFilter sepia = ColorFilter.matrix(<double>[
    0.393,
    0.769,
    0.189,
    0,
    0,
    0.349,
    0.686,
    0.168,
    0,
    0,
    0.272,
    0.534,
    0.131,
    0,
    0,
    0,
    0,
    0,
    1,
    0,
  ]);

  static const ColorFilter greyscale = ColorFilter.matrix(<double>[
    0.2126,
    0.7152,
    0.0722,
    0,
    0,
    0.2126,
    0.7152,
    0.0722,
    0,
    0,
    0.2126,
    0.7152,
    0.0722,
    0,
    0,
    0,
    0,
    0,
    1,
    0,
  ]);
}

class ColorMatrixFilter extends BaseFilter {
  ColorFilter colorFilter;
  ColorMatrixFilter(ColorFilter colorFilter) {
    this.colorFilter = colorFilter;
  }

  final _rect = GxRect();
  GxRect get filterRect => _rect;

  @override
  bool get isValid => colorFilter != null;

  @override
  void resolvePaint(Paint paint) {
    if (!isValid) return;
    paint.colorFilter = colorFilter;
  }
}
