import 'dart:ui';

import 'package:graphx/graphx/geom/gxrect.dart';

abstract class GxRenderable {
  void paint(Canvas canvas);
  GxRect getBounds();
}
