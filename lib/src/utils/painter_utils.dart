import 'dart:ui' as ui;

/// Contains utility functions for creating and manipulating [Paint] objects.
abstract class PainterUtils {
  /// An empty paint object.
  static ui.Paint emptyPaint = ui.Paint();

  /// A paint object with an alpha blend mode.
  static ui.Paint alphaPaint = ui.Paint()
    ..color = const ui.Color(0xff000000)
    ..blendMode = ui.BlendMode.srcATop;

  /// Factory constructor to ensure exception. Throws an exception if an attempt
  /// is made to instantiate this class.
  factory PainterUtils() {
    throw UnsupportedError(
      "Cannot instantiate PainterUtils. Use only static methods.",
    );
  }

  // Private constructor to prevent instantiation
  //PainterUtils._();

  /// Returns a paint object with the specified [alpha] value.
  ///
  /// This method creates a new paint object with an alpha value equal to the
  /// specified value. The [PainterUtils.alphaPaint] object is reused as a
  /// template and modified accordingly.
  static ui.Paint getAlphaPaint(double alpha) {
    alphaPaint.color = alphaPaint.color.withOpacity(alpha);
    return alphaPaint;
  }

  /// Returns a color filter that applies a color tint to an image.
  ///
  /// This method creates a color filter with a [BlendMode.srcATop] using the
  /// specified [color].
  static ui.ColorFilter getColorize(ui.Color color) {
    return ui.ColorFilter.mode(color, ui.BlendMode.srcATop);
  }
}
