import 'dart:ui' as ui;

import 'package:flutter_svg/flutter_svg.dart' as svg;
import 'package:graphx/graphx.dart';

/// Utilities to work with `flutter_svg`.
class SvgUtils {
  static Future<svg.DrawableRoot> svgStringToSvgDrawable(String rawSvg) async {
    return await svg.svg.fromSvgString(rawSvg, rawSvg);
  }

  static Future<ui.Picture> svgStringToPicture(String rawSvg) async {
    final svgRoot = await svg.svg.fromSvgString(rawSvg, rawSvg);
    return svgRoot.toPicture();
  }

  static void svgStringToCanvas(
    String rawSvg,
    ui.Canvas canvas, {
    bool scaleCanvas = true,
    bool clipCanvas = true,
    ui.Size scaleCanvasSize,
  }) async {
    final svgRoot = await svg.svg.fromSvgString(rawSvg, rawSvg);
    if (scaleCanvas) {
      svgRoot.scaleCanvasToViewBox(canvas, scaleCanvasSize);
    }
    if (clipCanvas) {
      svgRoot.clipCanvasToViewBox(canvas);
    }
    svgRoot.draw(canvas, null);
  }

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
}
