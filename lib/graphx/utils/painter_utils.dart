import 'dart:ui';

abstract class PainterUtils {
  static Paint emptyPaint = Paint();
  static Paint alphaPaint = Paint()
    ..color = Color(0xff000000)
    ..blendMode = BlendMode.srcATop;
}
