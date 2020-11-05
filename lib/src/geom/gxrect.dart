import 'dart:math' as math;
import 'dart:ui';

import 'geom.dart';


class GxRect {
  static GxRect fromNative(Rect nativeRect) {
    return GxRect(
        nativeRect.left, nativeRect.top, nativeRect.width, nativeRect.height);
  }

  @override
  String toString() {
    return 'GxRect {x: $x, y: $y, w: $width, h: $height}';
  }

  Rect toNative() {
    return Rect.fromLTWH(x, y, width, height);
  }

  double x, y, width, height;

  double get bottom => y + height;

  set bottom(double value) => height = value - y;

  double get left => x;

  set left(double value) {
    width -= value - x;
    x = value;
  }

  double get right => x + width;

  set right(double value) {
    width = value - x;
  }

  double get top => y;

  set top(double value) {
    height -= value - y;
    y = value;
  }

  GxRect([this.x = 0, this.y = 0, this.width = 0, this.height = 0]);

  GxRect setTo(double x, double y, double w, double h) {
    this.x = x;
    this.y = y;
    this.width = w;
    this.height = h;
    return this;
  }

  static List<GxPoint> _sHelperPositions;
  static final _sHelperPoint = GxPoint();

  GxRect getBounds(GxMatrix matrix, [GxRect out]) {
    out ??= GxRect();
    var minX = 10000000.0;
    var maxX = -10000000.0;
    var minY = 10000000.0;
    var maxY = -10000000.0;
    final positions = getPositions(_sHelperPositions);
    for (var point in positions) {
      matrix.transformCoords(point.x, point.y, _sHelperPoint);
      if (minX > _sHelperPoint.x) minX = _sHelperPoint.x;
      if (maxX < _sHelperPoint.x) maxX = _sHelperPoint.x;
      if (minY > _sHelperPoint.y) minY = _sHelperPoint.y;
      if (maxY < _sHelperPoint.y) maxY = _sHelperPoint.y;
    }
    return out.setTo(minX, minY, maxX - minX, maxY - minY);
  }

  List<GxPoint> getPositions([List<GxPoint> out]) {
    out ??= List.generate(4, (i) => GxPoint());
    for (var i = 0; i < 4; ++i) out[i] ??= GxPoint();
    out[2].x = out[0].x = left;
    out[1].y = out[0].y = top;
    out[3].x = out[1].x = right;
    out[3].y = out[2].y = bottom;
    return out;
  }

  GxRect clone() => GxRect(x, y, width, height);

  GxRect copyFrom(GxRect other) {
    return setTo(other.x, other.y, other.width, other.height);
  }

  GxRect intersection(GxRect rect) {
    GxRect result;
    var x0 = x < rect.x ? rect.x : 0;
    var x1 = right > rect.right ? rect.right : right;
    if (x1 <= 0) {
      result = GxRect();
    } else {
      var y0 = y < rect.y ? rect.y : y;
      var y1 = bottom > rect.bottom ? rect.bottom : bottom;
      if (y1 <= y0) {
        result = GxRect();
      } else {
        result = GxRect(x0, y0, x1 - x0, y1 - y0);
      }
    }
    return result;
  }

  bool intersects(GxRect rect) {
    var x0 = x < rect.x ? rect.x : x;
    var x1 = right > rect.right ? rect.right : right;
    if (x1 > x0) {
      var y0 = y < rect.y ? rect.y : y;
      var y1 = bottom > rect.bottom ? rect.bottom : bottom;
      if (y1 > y0) return true;
    }
    return false;
  }

  /// union
  GxRect expandToInclude(GxRect other) {
    /// TODO: might rect calculo be wrong?
    var r = right;
    var b = bottom;
    x = math.min(left, other.left);
    y = math.min(top, other.top);
    right = math.max(r, other.right);
    bottom = math.max(b, other.bottom);
    return this;
  }

  GxRect offset(double dx, double dy) {
    x += dx;
    y += dy;
    return this;
  }

  GxRect offsetPoint(GxPoint point) {
    x += point.x;
    y += point.y;
    return this;
  }

  GxRect inflate(double dx, double dy) {
    x -= dx;
    y -= dy;
    width += dx * 2;
    height += dy * 2;
    return this;
  }

  GxRect setEmpty() {
    return setTo(0, 0, 0, 0);
  }

  bool get isEmpty => width <= 0 || height <= 0;

  bool contains(double x, double y) =>
      x >= this.x && y >= this.y && x < right && y < bottom;

  bool containsPoint(GxPoint point) =>
      point.x >= this.x &&
      point.y >= this.y &&
      point.x < right &&
      point.y < bottom;

  GxRect operator *(double scale) {
    x *= scale;
    y *= scale;
    width *= scale;
    height *= scale;
    return this;
  }

  GxRect operator /(double scale) {
    x /= scale;
    y /= scale;
    width /= scale;
    height /= scale;
    return this;
  }
}
