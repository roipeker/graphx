import 'dart:ui' as ui;

import '../../../graphx.dart';

/// This is the base filter class for all filters in the GraphX library. A
/// filter is a graphical effect that modifies the appearance of a display
/// object.
class GBaseFilter {
  /// The [currentObject] property holds a reference to the display object that
  /// the filter is applied to. [OutlineFilter] uses this to adjust the filter
  /// size to the current object scale.
  GDisplayObject? currentObject;

  /// The [dirty] property is used to determine if the filter needs to be
  /// rebuilt.
  bool dirty = false;

  /// The [layerBounds] property holds the bounds of the display object.
  GRect? layerBounds;

  /// The [isValid] property determines if the filter is valid and can be
  /// applied.
  bool get isValid => true;

  /// The [buildFilter] method is called to rebuild the filter.
  void buildFilter() {}

  /// The [expandBounds] method is used to expand the bounds of the display object.
  /// The [layerBounds] parameter is the current bounds of the display object,
  /// and the [outputBounds] parameter is the bounds that should be expanded to.
  void expandBounds(GRect layerBounds, GRect outputBounds) {
    this.layerBounds = layerBounds;
  }

  /// This method is called to apply the filter's settings to the given paint
  /// object. The [paint] parameter is the paint object that is used to draw the
  /// display object.
  void resolvePaint(ui.Paint paint) {}

  /// The [update] method is called to check if the filter needs to be rebuilt.
  /// If the [dirty] property is true and the [isValid] property is also true,
  /// then the [buildFilter] method is called to rebuild the filter.
  void update() {
    if (dirty) {
      dirty = false;
      if (isValid) {
        buildFilter();
      }
    }
  }
}
