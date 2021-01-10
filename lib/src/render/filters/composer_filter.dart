import 'package:graphx/graphx.dart';

class ComposerFilter extends BaseFilter {
  final Paint paint = Paint();
  bool hideObject = false;

  @override
  void resolvePaint(Paint paint) {}

  void process(Canvas canvas, Function applyPaint, [int processCount = 1]) {
    /// todo: figure the area.
    // canvas.saveLayer(null, paint);
    // canvas.translate(_dx, _dy);
    // applyPaint(canvas);
    // canvas.restore();
    // canvas.translate(-40, -40);
  }
}
