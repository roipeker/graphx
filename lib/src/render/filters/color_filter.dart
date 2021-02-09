import 'dart:ui';

import '../../geom/gxrect.dart';
import 'blur_filter.dart';

class GColorFilters {
  static const ColorFilter invert = ColorFilter.matrix(<double>[
    -1, 0, 0, 0, 255, //
    0, -1, 0, 0, 255, //
    0, 0, -1, 0, 255, //
    0, 0, 0, 1, 0, //
  ]);

  static const ColorFilter sepia = ColorFilter.matrix(<double>[
    0.393, 0.769, 0.189, 0, 0, //
    0.349, 0.686, 0.168, 0, 0, //
    0.272, 0.534, 0.131, 0, 0, //
    0, 0, 0, 1, 0, //
  ]);

  static const ColorFilter greyscale = ColorFilter.matrix(<double>[
    0.2126, 0.7152, 0.0722, 0, 0, //
    0.2126, 0.7152, 0.0722, 0, 0, //
    0.2126, 0.7152, 0.0722, 0, 0, //
    0, 0, 0, 1, 0 //
  ]);

  static const ColorFilter lsd = ColorFilter.matrix(<double>[
    2, -0.4, 0.5, 0, 0, //
    -0.5, 2, -0.4, 0, 0, //
    -0.4, -0.5, 3, 0, 0, //
    0, 0, 0, 1, 0,
  ]);

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

class GColorMatrixFilter extends GBaseFilter {
  ColorFilter colorFilter;

  GColorMatrixFilter(this.colorFilter);

  final _rect = GRect();

  GRect get filterRect => _rect;

  @override
  bool get isValid => colorFilter != null;

  @override
  void resolvePaint(Paint paint) {
    if (!isValid) return;
    paint.colorFilter = colorFilter;
  }
}
