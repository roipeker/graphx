import 'dart:ui';

import '../../graphx.dart';

abstract class GxRenderable {
  void paint(Canvas canvas);
  GxRect getBounds();
}
