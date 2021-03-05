import 'dart:ui' as ui;

import '../../../graphx.dart';

class GComposerFilter extends GBaseFilter {
  final ui.Paint paint = ui.Paint();
  bool hideObject = false;

  @override
  void resolvePaint(ui.Paint paint) {}

  void process(ui.Canvas? canvas, Function applyPaint, [int processCount = 1]) {
    /// todo: figure the area.
    // canvas.saveLayer(null, paint);
    // canvas.translate(_dx, _dy);
    // applyPaint(canvas);
    // canvas.restore();
    // canvas.translate(-40, -40);
  }
}
