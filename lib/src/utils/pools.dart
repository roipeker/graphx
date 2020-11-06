import '../../graphx.dart';

abstract class Pool {
  static final _points = <GxPoint>[];
  static final _rectangles = <GxRect>[];
  static final _matrices = <GxMatrix>[];

  /// Get a GxPoint instance from the pool.
  static GxPoint getPoint([double x = 0, double y = 0]) {
    if (_points.isEmpty) return GxPoint(x, y);
    return _points.removeLast()
      ..x = x
      ..y = y;
  }

  /// Store a GxPoint in the pool.
  /// Remember to NOT KEEP any references to the object after moving it to
  /// the pool.
  static void putPoint(GxPoint point) {
    if (point != null) _points.add(point);
  }

  static GxMatrix getMatrix([
    double a = 1,
    double b = 0,
    double c = 0,
    double d = 1,
    double tx = 0,
    double ty = 0,
  ]) {
    if (_matrices.isEmpty) return GxMatrix(a, b, c, d, tx, ty);
    return _matrices.removeLast()..setTo(a, b, c, d, tx, ty);
  }

  static void putMatrix(GxMatrix matrix) {
    if (matrix != null) _matrices.add(matrix);
  }

  static GxRect getRect([
    double x = 0,
    double y = 0,
    double w = 0,
    double h = 0,
  ]) {
    if (_rectangles.isEmpty) return GxRect(x, y, w, h);
    return _rectangles.removeLast()..setTo(x, y, w, h);
  }

  static void putRect(GxRect rect) {
    if (rect != null) _rectangles.add(rect);
  }
}
