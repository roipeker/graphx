import '../../graphx.dart';

/// A mixin that provides a simple pooling mechanism for commonly-used
/// objects such as [GPoint], [GMatrix], and [GRect]. This can help reduce the
/// frequency of garbage collection and improve performance in some cases.
mixin Pool {
  /// A pool of GPoint objects.
  static final _points = <GPoint>[];

  /// A pool of GRect objects.
  static final _rectangles = <GRect>[];

  /// A pool of GMatrix objects.
  static final _matrices = <GMatrix>[];

  /// Get a [GMatrix] instance from the pool. If the pool is empty, a new
  /// [GMatrix] object is created and returned.
  static GMatrix getMatrix([
    double a = 1,
    double b = 0,
    double c = 0,
    double d = 1,
    double tx = 0,
    double ty = 0,
  ]) {
    if (_matrices.isEmpty) {
      return GMatrix(a, b, c, d, tx, ty);
    }
    return _matrices.removeLast()..setTo(a, b, c, d, tx, ty);
  }

  /// Get a [GPoint] instance from the pool. If the pool is empty, a new
  /// [GPoint] object is created and returned.
  static GPoint getPoint([double x = 0, double y = 0]) {
    if (_points.isEmpty) {
      return GPoint(x, y);
    }
    return _points.removeLast()
      ..x = x
      ..y = y;
  }

  /// Get a [GRect] instance from the pool.
  static GRect getRect([
    double x = 0,
    double y = 0,
    double w = 0,
    double h = 0,
  ]) {
    if (_rectangles.isEmpty) {
      return GRect(x, y, w, h);
    }
    return _rectangles.removeLast()..setTo(x, y, w, h);
  }

  /// Store a [GMatrix] in the pool. Remember to not keep any references to the
  /// object after moving it to the pool.
  static void putMatrix(GMatrix matrix) {
    _matrices.add(matrix);
  }

  /// Store a [GPoint] in the pool. It is important not to keep any references
  /// to the object after returning it to the pool.
  static void putPoint(GPoint point) {
    _points.add(point);
  }

  /// Store a [GRect] in the pool.
  /// Remember to not keep any references to the object after moving it to
  /// the pool.
  static void putRect(GRect rect) {
    _rectangles.add(rect);
  }
}
