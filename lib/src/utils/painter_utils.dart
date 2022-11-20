import 'dart:ui' as ui;

abstract class PainterUtils {
  static ui.Paint emptyPaint = ui.Paint();
  static ui.Paint alphaPaint = ui.Paint()
    ..color = const ui.Color(0xff000000)
    ..blendMode = ui.BlendMode.srcATop;

  static ui.Paint getAlphaPaint(double alpha) {
    alphaPaint.color = alphaPaint.color.withOpacity(alpha);
    return alphaPaint;
  }

  static ui.ColorFilter getColorize(ui.Color color) =>
      ui.ColorFilter.mode(color, ui.BlendMode.srcATop);
}
