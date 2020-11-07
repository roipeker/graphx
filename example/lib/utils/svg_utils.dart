import 'dart:ui';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:graphx/graphx.dart';

/// Utility functions to work with flutter_svg.
/// copy and paste in your project.
class SvgUtils {
  static Future<Picture> svgStringToPicutre(String rawSvg) async {
    final svgRoot = await svg.fromSvgString(rawSvg, rawSvg);
    return svgRoot.toPicture();
  }

  static void svgStringToCanvas(
    String rawSvg,
    Canvas canvas, {
    bool scaleCanvas = true,
    bool clipCanvas = true,
    Size scaleCanvasSize,
  }) async {
    final DrawableRoot svgRoot = await svg.fromSvgString(rawSvg, rawSvg);
    if (scaleCanvas) {
      svgRoot.scaleCanvasToViewBox(canvas, scaleCanvasSize);
    }
    if (clipCanvas) {
      svgRoot.clipCanvasToViewBox(canvas);
    }
    svgRoot.draw(canvas, null);
  }

  static Future<SvgData> svgDataFromString(String rawSvg) async {
    final DrawableRoot svgRoot = await svg.fromSvgString(rawSvg, rawSvg);
    var obj = SvgData();
    obj.hasContent = svgRoot.hasDrawableContent;
    obj.picture = svgRoot.toPicture();
    obj.viewBox = GxRect.fromNative(svgRoot.viewport.viewBoxRect);
    obj.size =
        GxRect(0, 0, svgRoot.viewport.size.width, svgRoot.viewport.size.height);
    return obj;
  }
}
