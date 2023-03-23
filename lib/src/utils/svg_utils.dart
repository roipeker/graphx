import 'dart:ui';

import 'package:flutter_svg/flutter_svg.dart' as svg;

import '../../graphx.dart';

/// Utilities to work with `flutter_svg`.
///
class SvgUtils {
  /// Factory constructor to ensure exception. Throws an exception if an attempt
  /// is made to instantiate this class.
  factory SvgUtils() {
    throw UnsupportedError(
      "Cannot instantiate SvgUtils. Use only static methods.",
    );
  }

  /// Private constructor to prevent instantiation
  SvgUtils._();

  /// Parses a raw SVG string into a [SvgData] object.
  ///
  /// The returned [SvgData] object contains information about the SVG content,
  /// such as whether it contains drawable content and its size and viewBox.
  /// To be used on [GSvgShape].
  static Future<SvgData> svgDataFromString(String rawSvg) async {
    final svgRoot = await svg.svg.fromSvgString(rawSvg, rawSvg);
    var obj = SvgData();
    obj.hasContent = svgRoot.hasDrawableContent;
    obj.picture = svgRoot.toPicture();
    obj.viewBox = GRect.fromNative(svgRoot.viewport.viewBoxRect);
    obj.size = GRect(
      0,
      0,
      svgRoot.viewport.size.width,
      svgRoot.viewport.size.height,
    );
    return obj;
  }

  /// Parses a raw SVG string and draws it on  a [Canvas].
  ///
  /// The [scaleCanvas] parameter specifies whether the canvas should be scaled
  /// to fit the SVG viewbox. The [clipCanvas] parameter specifies whether the
  /// canvas should be clipped to the bounds of the viewBox attribute.
  /// The [scaleCanvasSize] parameter is used to specify the size to which the
  /// canvas should be scaled.
  static void svgStringToCanvas(
    String rawSvg,
    Canvas canvas, {
    bool scaleCanvas = true,
    bool clipCanvas = true,
    required Size scaleCanvasSize,
  }) async {
    final svgRoot = await svg.svg.fromSvgString(rawSvg, rawSvg);
    if (scaleCanvas) {
      svgRoot.scaleCanvasToViewBox(canvas, scaleCanvasSize);
    }
    if (clipCanvas) {
      svgRoot.clipCanvasToViewBox(canvas);
    }
    svgRoot.draw(canvas, Rect.zero);
  }

  /// Parses a raw SVG string into a [Picture] object.
  ///
  /// The [size] parameter can be used to specify the size of the picture. The
  /// [colorFilter] parameter can be used to apply a color filter to the picture.
  /// If [clipToViewBox] is true, the picture will be clipped to the bounds of
  /// the viewBox attribute.
  static Future<Picture> svgStringToPicture(
    String rawSvg, {
    Size? size,
    ColorFilter? colorFilter,
    bool clipToViewBox = true,
  }) async {
    final svgRoot = await svg.svg.fromSvgString(rawSvg, rawSvg);
    return svgRoot.toPicture(
      size: size,
      colorFilter: colorFilter,
      clipToViewBox: clipToViewBox,
    );
  }

  /// Parses a raw SVG string and returns the corresponding `DrawableRoot`.
  static Future<svg.DrawableRoot> svgStringToSvgDrawable(String rawSvg) async {
    return await svg.svg.fromSvgString(rawSvg, rawSvg);
  }
}
