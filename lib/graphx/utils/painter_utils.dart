import 'dart:ui';

abstract class PainterUtils {
  static Paint emptyPaint = Paint();
  static Paint alphaPaint = Paint()
    ..color = Color(0xff000000)
    ..blendMode = BlendMode.srcATop;

  static Paint getAlphaPaint(double alpha) {
    alphaPaint.color = alphaPaint.color.withOpacity(alpha);
    return alphaPaint;
  }
}
