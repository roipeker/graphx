import 'dart:ui' as ui;

import '../../../graphx.dart';

/// A base class for filters that modify the appearance of content.
///
/// This class defines a common interface for all filters, including the ability
/// to expand the bounds of the filtered content, check whether the filter has
/// any effect, and resolve the paint object used to apply the filter to the
/// content.
/// This filter can be used to apply a painting function to a canvas and blend
/// the resulting content with other content layers using the `Canvas.saveLayer`
/// and `Canvas.restore` methods. The filter can be configured to hide the
/// content behind it by setting the `hideObject` property to `true`.
abstract class GComposerFilter extends GBaseFilter {
  /// The paint object used to apply the painting function.
  final ui.Paint paint = ui.Paint();

  /// Whether to hide the content behind the filter.
  bool hideObject = false;

  /// Applies the filter effect to the specified paint object.
  ///
  /// The [paint] parameter is the paint object to apply the filter effect to.
  ///
  /// If the filter is not valid (empty), i.e., [isValid] returns `false`, this
  /// method does nothing.
  @override
  void resolvePaint(ui.Paint paint) {}

  /// Applies the painting function to the specified canvas and blends the
  /// resulting content with other content layers using the [Canvas.saveLayer]
  /// and [Canvas.restore] methods in subclasses.
  void process(
    ui.Canvas canvas,
    Function applyPaint, [
    int processCount = 1,
  ]) {
    /// TODO: figure the area.
    // canvas.saveLayer(null, paint);
    // canvas.translate(_dx, _dy);
    // applyPaint(canvas);
    // canvas.restore();
    // canvas.translate(-40, -40);
  }
}
