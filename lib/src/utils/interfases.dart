import 'dart:ui';

import '../../graphx/geom/gxrect.dart';

abstract class GxRenderable {
  void paint(Canvas canvas);
  GxRect getBounds();
}
