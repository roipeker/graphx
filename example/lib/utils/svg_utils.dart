import 'dart:ui';

import 'package:flutter_svg/flutter_svg.dart' as svg;
import 'package:graphx/graphx.dart';

/// Utilities to work with `flutter_svg`.
/// Also available in graphx_svg_utils (https://github.com/roipeker/graphx_svg_utils)
///
final class SvgUtils {
  /// Factory constructor to ensure exception. Throws an exception if an attempt
  /// is made to instantiate this class.
  factory SvgUtils() {
    throw UnsupportedError(
      "Cannot instantiate SvgUtils. Use only static methods.",
    );
  }

  // Private constructor to prevent instantiation
  SvgUtils._();

  /// Parses a raw SVG string into a [SvgData] object.
  ///
  /// The returned [SvgData] object contains information about the SVG content,
  /// such as whether it contains drawable content and its size and viewBox.
  /// To be used on [GSvgShape].
  static Future<SvgData> svgDataFromString(String rawSvg) async {
    final svgRoot = await svg.vg.loadPicture(svg.SvgStringLoader(rawSvg), null);
    var obj = SvgData();
    obj.hasContent = svgRoot.size.isEmpty == false;
    obj.picture = svgRoot.picture;
    obj.viewBox = GRect(0, 0, svgRoot.size.width, svgRoot.size.height);
    obj.size = GRect(
      0,
      0,
      svgRoot.size.width,
      svgRoot.size.height,
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
    final svgRoot = await svg.vg.loadPicture(svg.SvgStringLoader(rawSvg), null);
    final pictureSize = svgRoot.size;
    final picture = svgRoot.picture;
    canvas.save();
    if (scaleCanvas) {
      final scaleX = scaleCanvasSize.width / pictureSize.width;
      final scaleY = scaleCanvasSize.height / pictureSize.height;
      final scale = scaleX < scaleY ? scaleX : scaleY;
      canvas.scale(scale, scale);
    }
    if (clipCanvas) {
      canvas
          .clipRect(Rect.fromLTWH(0, 0, pictureSize.width, pictureSize.height));
    }
    canvas.drawPicture(picture);
    canvas.restore();
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
    final svgRoot = await svg.vg.loadPicture(svg.SvgStringLoader(rawSvg), null);
    final pictureSize = svgRoot.size;
    final picture = svgRoot.picture;

    if (size == null && colorFilter == null && !clipToViewBox) {
      return picture;
    }

    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);

    canvas.save();

    if (size != null) {
      final scaleX = size.width / pictureSize.width;
      final scaleY = size.height / pictureSize.height;
      canvas.scale(scaleX, scaleY);
    }

    if (clipToViewBox) {
      canvas
          .clipRect(Rect.fromLTWH(0, 0, pictureSize.width, pictureSize.height));
    }

    if (colorFilter != null) {
      canvas.saveLayer(
        Rect.fromLTWH(0, 0, pictureSize.width, pictureSize.height),
        Paint()..colorFilter = colorFilter,
      );
    }

    canvas.drawPicture(picture);

    if (colorFilter != null) {
      canvas.restore();
    }

    canvas.restore();

    return recorder.endRecording();
  }
}
