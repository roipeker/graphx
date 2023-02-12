import 'dart:ui' as ui;

import '../../../graphx.dart';

/// Base class for all filters.
class GBaseFilter {
  // Used to store the current object being rendered.
  // `OutlineFilter` uses this to adjust the filter size to the current
  // object scale.
  GDisplayObject? currentObject;

  void resolvePaint(ui.Paint paint) {}

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
  GRect? layerBounds;

  void expandBounds(GRect layerBounds, GRect outputBounds) {
    this.layerBounds = layerBounds;
  }
}
