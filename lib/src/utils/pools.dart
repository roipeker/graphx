import '../../graphx.dart';

mixin Pool {
  static final _points = <GPoint>[];
  static final _rectangles = <GRect>[];
  static final _matrices = <GMatrix>[];

  /// Get a GxPoint instance from the pool.
  static GPoint getPoint([double x = 0, double y = 0]) {
    if (_points.isEmpty) return GPoint(x, y);
    return _points.removeLast()
      ..x = x
      ..y = y;
  }

  /// Store a GxPoint in the pool.
  /// Remember to NOT KEEP any references to the object after moving it to
  /// the pool.
  static void putPoint(GPoint point) {
    if (point != null) _points.add(point);
  }

  static GMatrix getMatrix([
    double a = 1,
    double b = 0,
    double c = 0,
    double d = 1,
    double tx = 0,
    double ty = 0,
  ]) {
    if (_matrices.isEmpty) return GMatrix(a, b, c, d, tx, ty);
    return _matrices.removeLast()..setTo(a, b, c, d, tx, ty);
  }

  static void putMatrix(GMatrix matrix) {
    if (matrix != null) _matrices.add(matrix);
  }

  static GRect getRect([
    double x = 0,
    double y = 0,
    double w = 0,
    double h = 0,
  ]) {
    if (_rectangles.isEmpty) return GRect(x, y, w, h);
    return _rectangles.removeLast()..setTo(x, y, w, h);
  }

  static void putRect(GRect rect) {
    if (rect != null) _rectangles.add(rect);
  }
}
