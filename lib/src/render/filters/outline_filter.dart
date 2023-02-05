import 'dart:ui';

import '../../../graphx.dart';

/// Creates a "border" around the target object.
class OutlineFilter extends GComposerFilter {
  /// If autoScale, is the inverse of the currentObject. world scale
  double _ownerScale = 1.0;
  late Color color;
  late double width;
  late bool adjustToScale = false;

  OutlineFilter({
    this.color = kColorBlack,
    this.width = 1,
    this.adjustToScale = false,
  }) {
    dirty = true;
  }

  final _rect = GRect();

  GRect get filterRect => _rect;

  @override
  void expandBounds(GRect layerBounds, GRect outputBounds) {
    super.expandBounds(layerBounds, outputBounds);
    _rect.copyFrom(layerBounds).inflate(2, 2);
    outputBounds.expandToInclude(_rect);
  }

  @override
  bool get isValid => width > 0 && color.alpha > 0;

  @override
  void buildFilter() {
    paint.filterQuality = FilterQuality.medium;
    paint.isAntiAlias = true;
    _updateProperties();
  }

  void _updateProperties() {
    var worldScale = adjustToScale ? _ownerScale : 1;
    var radius = width * (1 / worldScale);
    paint.imageFilter = ImageFilter.dilate(radiusX: radius, radiusY: radius);
    paint.colorFilter = ColorFilter.mode(color, BlendMode.srcATop);
  }

  @override
  void process(Canvas canvas, Function applyPaint, [int processCount = 1]) {
    if (adjustToScale) {
      if (currentObject != null) {
        final worldScale = currentObject!.worldScaleX;
        if (worldScale != _ownerScale) {
          _ownerScale = worldScale;
          _updateProperties();
        }
      }
    }

    canvas.saveLayer(null, paint);
    applyPaint(canvas);
    canvas.restore();
  }
}
