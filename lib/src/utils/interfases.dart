import 'dart:ui' as ui;

import '../../graphx.dart';

abstract class GxRenderable {
  void paint(ui.Canvas canvas);
  GRect getBounds();
}
