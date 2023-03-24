import 'dart:ui';

import '../../../graphx.dart';

/// Creates a "border" around the target object. A filter that outlines a
/// display object  by applying a stroke around it.
///
/// The `color` property specifies the color of the stroke, and the `width`
/// property specifies its thickness.
///
/// The `adjustToScale` property controls whether the stroke width is scaled
/// based on the object's scale or remains fixed. If `adjustToScale` is set to
/// true, the stroke width adapts to the "world" scale of the object.
///
/// This filter is not supported on web canvases.
class OutlineFilter extends GComposerFilter {
  /// The scale of the owner object that the filter is applied to. This is used
  /// to adjust the filter's properties based on the owner's scale, if
  /// [adjustToScale] is set to `true`. The default value is `1.0`.
  double _ownerScale = 1.0;

  /// The color of the outline.
  late Color color;

  /// The width of the outline, in logical pixels.
  late double width;

  /// Whether or not to adjust the outline's width to match the scale of the
  /// owner.
  late bool adjustToScale = false;

  // Represents the bounds of the filter.
  final _rect = GRect();

  /// Creates a new `OutlineFilter` with the specified properties.
  ///
  /// The [color] parameter is used to set the color of the outline. The default
  /// value is `kColorBlack`.
  ///
  /// The [width] parameter is used to set the width of the outline, in logical
  /// pixels. The default value is `1`.
  ///
  /// The [adjustToScale] parameter is used to adjust the filter's properties
  /// based on the owner's scale. If this parameter is set to `true`, the
  /// filter's properties will be adjusted based on the scale of the object that
  /// the filter is applied to. The default value is `false`.
  OutlineFilter({
    this.color = kColorBlack,
    this.width = 1,
    this.adjustToScale = false,
  }) {
    dirty = true;
  }

  /// Returns the filter rectangle bounds.
  GRect get filterRect {
    return _rect;
  }

  /// (Internal usage)
  /// Determines whether the filter is valid and can be applied.
  ///
  /// This getter returns `true` if the width of the outline is greater than `0`
  /// and the alpha channel of the outline color is greater than `0`.
  @override
  bool get isValid {
    return width > 0 && color.alpha > 0;
  }

  /// (Internal usage)
  /// Builds the filter and sets its properties.
  ///
  /// This method is called whenever the filter needs to be rebuilt, such as
  /// when its properties are changed. It sets the filter quality to medium,
  /// enables anti-aliasing to then updates the filter's properties.
  @override
  void buildFilter() {
    paint.filterQuality = FilterQuality.medium;
    paint.isAntiAlias = true;
    _updateProperties();
  }

  /// (Internal usage)
  /// Expands the bounds of the filtered object to include the outline.
  ///
  /// This method overrides the default implementation of `expandBounds` in the
  /// `GComposerFilter` class. It expands the bounds of the filtered object by
  /// creating a new `GRect` that is the same size as the layer bounds, and then
  /// inflating it by 2 logical pixels in all directions. The resulting `GRect`
  /// is then added to the output bounds.
  ///
  /// The [layerBounds] parameter is the original bounds of the filtered object.
  ///
  /// The [outputBounds] parameter is the bounds that the filtered object will
  /// be rendered to.
  @override
  void expandBounds(GRect layerBounds, GRect outputBounds) {
    super.expandBounds(layerBounds, outputBounds);
    _rect.copyFrom(layerBounds).inflate(2, 2);
    outputBounds.expandToInclude(_rect);
  }

  /// (Internal usage)
  /// Applies the filter to the given canvas.
  ///
  /// This method applies the filter to the given canvas during the rendering
  /// process . It updates the filter's properties based on the value of the
  /// [adjustToScale] property and the current scale of the owner object (if
  /// applicable). It then saves the current canvas state, applies the filter
  /// using the [applyPaint] callback function, and restores the canvas state.
  ///
  /// The [canvas] parameter is the canvas that the filter will be applied to.
  ///
  /// The [applyPaint] parameter is a callback function that applies the paint
  /// properties to the canvas.
  ///
  /// The [processCount] parameter is the number of times that the filter should
  /// be applied to the canvas. This parameter is not currently used.
  ///
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

  /// Updates the properties of the filter.
  ///
  /// This method is called by the [buildFilter] method to update the properties
  /// of the filter based on its current settings. It adjusts the filter's
  /// properties based on the value of [adjustToScale] and the current scale of
  /// the owner object, if applicable. The resulting properties are then used on
  /// the [paint].
  void _updateProperties() {
    var worldScale = adjustToScale ? _ownerScale : 1;
    var radius = width * (1 / worldScale);
    paint.imageFilter = ImageFilter.dilate(radiusX: radius, radiusY: radius);
    paint.colorFilter = ColorFilter.mode(color, BlendMode.srcATop);
  }
}
